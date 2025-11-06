# Workflow Changes - Request Status System

## Overview
Updated the asset borrowing system to keep requests in the database throughout their lifecycle instead of immediately deleting them after approval/rejection. This provides better tracking and allows students to see their requests at all stages.

## Database Changes

### 1. Requests Table - Added Status Column
- **File**: `database/update_requests_schema.js`
- **Change**: Added `status` ENUM column to `requests` table
- **Values**: 'Pending', 'Approved', 'Returned', 'Rejected'
- **Default**: 'Pending'

```sql
ALTER TABLE `requests` 
  ADD COLUMN `status` ENUM('Pending','Approved','Returned','Rejected') 
  NOT NULL DEFAULT 'Pending' AFTER `return_date`
```

## Backend API Changes (app.js)

### 1. Updated GET /api/requests
- **Before**: Filter by `asset.status = 'Pending'`
- **After**: Filter by `request.status = 'Pending'`
- **Added**: Include `r.status` in SELECT query
- **Added**: ORDER BY `r.req_id DESC`

### 2. Updated GET /api/requests/:userId
- **Added**: Include `r.status` in SELECT query
- **Added**: ORDER BY `r.req_id DESC` to show most recent first

### 3. NEW GET /api/requests/returned/all
- **Purpose**: Fetch requests with status='Returned' for staff return page
- **Returns**: All returned requests with borrower info

### 4. Updated PUT /api/requests/:requestId (action='approve')
- **Before**: Added to history, then deleted request
- **After**: Only updates `requests.status` to 'Approved', keeps request in table
- **Removed**: History insert and request delete operations

### 5. Updated PUT /api/requests/:requestId (action='reject')
- **No Change**: Still adds to history with status='Rejected' and deletes request

### 6. NEW PUT /api/requests/:requestId (action='return')
- **Purpose**: Student-initiated return
- **Action**: Updates `requests.status` from 'Approved' to 'Returned'
- **Note**: Asset remains in 'Borrowed' status until staff confirms

### 7. NEW PUT /api/requests/:requestId (action='confirm_return')
- **Purpose**: Staff confirmation of returned asset
- **Actions**:
  1. Updates asset to 'Available'
  2. Adds to history with status='Returned'
  3. Deletes request from requests table

### 8. NEW GET /api/history/approver/:approverId
- **Purpose**: Filter history by approver_id for lecturers
- **Returns**: All history records approved by specific lecturer

## Frontend Changes

### 1. RequestService (lib/services/request_service.dart)
- **Added**: `getReturnedRequests()` - Fetches requests with status='Returned'
- **Added**: `confirmReturn(requestId, staffId, approverId)` - Staff confirms return
- **Updated**: `returnAsset(requestId)` - Student marks approved request as returned

### 2. HistoryService (lib/services/history_service.dart)
- **Added**: `getApproverHistory(approverId)` - Fetches history filtered by approver_id

### 3. std_status.dart (Student Status Page)
**Major Rewrite**:
- **Before**: Showed all requests in horizontal scroll, used asset status
- **After**: Shows only most recent request (single card), uses request status
- **Status Mapping**:
  - `pending` → "Pending Approval" (Amber)
  - `approved` → "Approved (Borrowed)" (Green) - Shows Return button
  - `returned` → "Return Submitted" (Blue)
- **Return Button**: Only visible when status='approved'
- **Return Action**: Calls `RequestService.returnAsset()` → Updates status to 'Returned'

### 4. stf_return.dart (Staff Return Page)
**Major Update**:
- **Before**: Fetched from `history` table WHERE status='Approved' AND asset.status='Borrowed'
- **After**: Fetches from `requests` table WHERE status='Returned'
- **Service**: Changed from `AssetService.getBorrowedAssets()` to `RequestService.getReturnedRequests()`
- **Confirm Action**: Changed from `AssetService.returnAsset()` to `RequestService.confirmReturn()`
- **UI**: Updated button text from "Return" to "Confirm Return"

### 5. lec_history.dart (Lecturer History Page)
**Filter Update**:
- **Before**: `HistoryService.getAllHistory()` - Showed all history
- **After**: `HistoryService.getApproverHistory(currentUserId)` - Shows only approved by this lecturer
- **Updated**: Status field changed from `approval` to `status` enum

### 6. std_history.dart (Student History Page)
- **No Changes**: Already correctly filtered by user_id

### 7. stf_history.dart (Staff History Page)
- **No Changes**: Already correctly shows all history

## New Workflow Flow

### Student Request to Return Process
```
1. Student creates request
   └─> requests.status = 'Pending'
   └─> asset.status = 'Pending'

2. Lecturer approves
   └─> requests.status = 'Approved' (NOT DELETED)
   └─> asset.status = 'Borrowed'
   └─> Request stays in requests table

3. Student clicks "Return" button in std_status
   └─> requests.status = 'Returned'
   └─> asset.status = 'Borrowed' (unchanged)

4. Staff confirms return in stf_return page
   └─> asset.status = 'Available'
   └─> Add to history with status='Returned'
   └─> DELETE from requests table
```

### Lecturer Reject Process (Unchanged)
```
1. Student creates request
   └─> requests.status = 'Pending'

2. Lecturer rejects
   └─> asset.status = 'Available'
   └─> Add to history with status='Rejected'
   └─> DELETE from requests table
```

## Benefits of New Workflow

1. **Better Tracking**: Students can see their request status at all times
2. **Clear States**: Pending → Approved → Returned → Confirmed (in history)
3. **Student Control**: Students initiate the return process
4. **Staff Verification**: Staff confirms the asset is actually returned
5. **History Accuracy**: History only contains finalized transactions
6. **Filtered Views**: 
   - Students see only their requests/history
   - Lecturers see only requests they approved
   - Staff sees everything

## Migration Notes

To apply these changes to an existing system:
1. Run `node database/update_requests_schema.js` to add status column
2. Restart the backend server (app.js)
3. Deploy updated Flutter app

## Testing Checklist

- [ ] Student can create request
- [ ] Lecturer can approve request (request stays in table with status='Approved')
- [ ] Student can see approved request in std_status with Return button
- [ ] Student can click Return button (status changes to 'Returned')
- [ ] Staff can see returned request in stf_return page
- [ ] Staff can confirm return (moves to history, deletes request, asset becomes available)
- [ ] Student history shows only their records
- [ ] Lecturer history shows only records they approved
- [ ] Staff history shows all records
- [ ] Rejection still works (adds to history, deletes request)
