-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2025 at 08:43 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `assets_borrowing`
--

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `asset_id` int(11) NOT NULL,
  `asset_name` varchar(255) NOT NULL,
  `asset_type` enum('Laptop','Mouse','Keyboard','Monitor','Camera','Tablet','Projector','Adapter','Storage','Headphones','Webcam') NOT NULL,
  `image_src` text DEFAULT NULL,
  `status` enum('Available','Pending','Borrowed','Disabled','Returned') NOT NULL DEFAULT 'Available',
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assets`
--

INSERT INTO `assets` (`asset_id`, `asset_name`, `asset_type`, `image_src`, `status`, `description`) VALUES
(11, 'Dell XPS 15 Laptop', 'Laptop', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500', 'Borrowed', 'High-performance laptop with 16GB RAM, Intel i7 processor'),
(12, 'MacBook Pro 14\"', 'Laptop', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', 'Borrowed', 'Apple M2 chip, 32GB RAM, perfect for development'),
(13, 'HP EliteBook 840', 'Laptop', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500', 'Available', 'Business laptop with security features'),
(14, 'Logitech MX Master 3', 'Mouse', 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500', 'Available', 'Wireless ergonomic mouse with precision tracking'),
(15, 'Razer DeathAdder V3', 'Mouse', 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=500', 'Borrowed', 'Gaming mouse with RGB lighting'),
(16, 'Mechanical Keyboard', 'Keyboard', 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500', 'Available', 'Cherry MX switches, RGB backlight'),
(17, 'Logitech K380', 'Keyboard', 'https://images.unsplash.com/photo-1595225476474-87563907a212?w=500', 'Available', 'Compact wireless keyboard for multi-device'),
(18, 'Dell UltraSharp 27\"', 'Monitor', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500', 'Available', '4K monitor with USB-C connectivity'),
(19, 'LG 34\" Ultrawide', 'Monitor', 'https://images.unsplash.com/photo-1585792180666-f7347c490ee2?w=500', 'Available', 'Curved ultrawide monitor for multitasking'),
(20, 'Canon EOS R6', 'Camera', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&q=80', 'Available', 'Professional mirrorless camera with 20MP sensor'),
(21, 'Sony Alpha a7 III', 'Camera', 'https://cg.lnwfile.com/_/cg/_raw/2c/gh/tl.jpg', 'Available', 'Full-frame camera with excellent low-light performance'),
(22, 'iPad Pro 12.9\"', 'Tablet', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500', 'Available', 'Latest iPad Pro with M2 chip and ProMotion display'),
(23, 'Samsung Galaxy Tab S9', 'Tablet', 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500', 'Available', 'Android tablet with S Pen included'),
(24, 'Portable Projector', 'Projector', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=500', 'Available', 'Mini projector for presentations, 1080p HD'),
(25, 'Epson PowerLite', 'Projector', 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=500', 'Available', 'High-brightness projector for large rooms'),
(26, 'USB-C Hub 7-in-1', 'Adapter', 'https://images.unsplash.com/photo-1625948515291-69613efd103f?w=500', 'Available', 'Multi-port adapter with HDMI, USB 3.0, SD card reader'),
(27, 'External SSD 1TB', 'Storage', 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=500', 'Borrowed', 'Samsung T7 portable SSD with fast transfer speeds'),
(28, 'Wireless Headphones', 'Headphones', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'Available', 'Sony WH-1000XM5 with noise cancellation'),
(29, 'Webcam HD 1080p', 'Webcam', 'https://m.media-amazon.com/images/I/71eGb1FcyiL.jpg', 'Available', 'Logitech C920 with stereo audio'),
(30, 'Drawing Tablet', 'Tablet', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=500', 'Disabled', 'Wacom Intuos Pro with pressure-sensitive pen');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `his_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `borrowed_date` date DEFAULT NULL,
  `approver_id` bigint(20) DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `reject_reason` varchar(255) DEFAULT NULL,
  `status` enum('Approved','Rejected','Returned') NOT NULL,
  `staff_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`his_id`, `request_id`, `asset_id`, `user_id`, `borrowed_date`, `approver_id`, `return_date`, `reject_reason`, `status`, `staff_id`) VALUES
(14, 15, 14, 6631501, '2025-11-06', 20001, '2025-11-07', 'idk why', 'Rejected', NULL),
(15, 16, 12, 6631501, '2025-11-06', 20002, '2025-11-07', NULL, 'Returned', 10001),
(19, 17, 11, 663150, '2025-11-06', 20001, '2025-11-07', 'Asset not available for this period', 'Rejected', NULL),
(20, 18, 11, 663150, '2025-11-07', 20001, '2025-11-08', 'Asset not available for this period', 'Rejected', NULL),
(21, 19, 12, 663150, '2025-11-07', 20002, '2025-11-07', NULL, 'Returned', 10002),
(22, 21, 18, 5555555555, '2025-11-07', 20001, '2025-11-08', 'Asset not available for this period', 'Rejected', NULL),
(23, 23, 11, 7777777777, '2025-11-07', 20002, '2025-11-08', 'Asset not available for this period', 'Rejected', NULL),
(24, 24, 14, 7777777777, '2025-11-07', 20002, '2025-11-07', NULL, 'Returned', 10001),
(25, 25, 11, 1234567890, '2025-11-07', 20002, '2025-11-08', 'Asset not available for this period', 'Rejected', NULL),
(26, 25, 11, 1234567890, '2025-11-07', 20002, NULL, NULL, 'Approved', NULL),
(27, 25, 11, 1234567890, '2025-11-07', 20002, NULL, NULL, 'Approved', NULL),
(28, 26, 11, 1234567890, '2025-11-07', 20002, '2025-11-07', NULL, 'Returned', 10001),
(29, 22, 15, 5555555555, '2025-11-07', 20001, NULL, NULL, 'Approved', NULL),
(30, 29, 13, 5555555555, '2025-11-09', 20001, '2025-11-10', 'jkghjhgjg', 'Rejected', NULL),
(31, 28, 27, 6631501, '2025-11-09', 20001, NULL, NULL, 'Approved', NULL),
(32, 30, 16, 7777777777, '2025-11-09', 20002, '2025-11-10', 'ggggggggg', 'Rejected', NULL),
(33, 27, 22, 663150, '2025-11-09', 20002, '2025-11-10', 'll', 'Rejected', NULL),
(34, 33, 14, 663150, '2025-11-09', 20003, '2025-11-10', ';;;', 'Rejected', NULL),
(35, 32, 11, 7777777777, '2025-11-09', 20003, '2025-11-10', '///', 'Rejected', NULL),
(36, 31, 12, 5555555555, '2025-11-09', 20003, '2025-11-10', ';;', 'Rejected', NULL),
(37, 36, 17, 663150, '2025-11-09', 20002, '2025-11-10', 'g', 'Rejected', NULL),
(38, 35, 12, 7777777777, '2025-11-09', 20002, NULL, NULL, 'Approved', NULL),
(39, 34, 11, 5555555555, '2025-11-09', 20002, '2025-11-10', 'dfg', 'Rejected', NULL),
(40, 37, 16, 5555555555, '2025-11-10', 20001, '2025-11-11', 'f', 'Rejected', NULL),
(41, 39, 13, 663150, '2025-11-10', 20002, '2025-11-11', 'f', 'Rejected', NULL),
(42, 40, 14, 6631501, '2025-11-10', 20002, '2025-11-11', 'sdfsdf', 'Rejected', NULL),
(43, 38, 11, 7777777777, '2025-11-10', 20002, NULL, NULL, 'Approved', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `req_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date NOT NULL,
  `status` enum('Pending','Approved','Returned','Rejected') NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`req_id`, `asset_id`, `user_id`, `borrow_date`, `return_date`, `status`) VALUES
(15, 14, 6631501, '2025-11-06', '2025-11-07', 'Rejected'),
(16, 12, 6631501, '2025-11-06', '2025-11-07', 'Returned'),
(17, 11, 663150, '2025-11-06', '2025-11-07', 'Rejected'),
(18, 11, 663150, '2025-11-07', '2025-11-08', 'Rejected'),
(19, 12, 663150, '2025-11-07', '2025-11-08', 'Returned'),
(21, 18, 5555555555, '2025-11-07', '2025-11-08', 'Rejected'),
(22, 15, 5555555555, '2025-11-07', '2025-11-08', 'Approved'),
(23, 11, 7777777777, '2025-11-07', '2025-11-08', 'Rejected'),
(24, 14, 7777777777, '2025-11-07', '2025-11-08', 'Returned'),
(25, 11, 1234567890, '2025-11-07', '2025-11-08', 'Approved'),
(26, 11, 1234567890, '2025-11-07', '2025-11-08', 'Returned'),
(27, 22, 663150, '2025-11-09', '2025-11-10', 'Rejected'),
(28, 27, 6631501, '2025-11-09', '2025-11-10', 'Approved'),
(29, 13, 5555555555, '2025-11-09', '2025-11-10', 'Rejected'),
(30, 16, 7777777777, '2025-11-09', '2025-11-10', 'Rejected'),
(31, 12, 5555555555, '2025-11-09', '2025-11-10', 'Rejected'),
(32, 11, 7777777777, '2025-11-09', '2025-11-10', 'Rejected'),
(33, 14, 663150, '2025-11-09', '2025-11-10', 'Rejected'),
(34, 11, 5555555555, '2025-11-09', '2025-11-10', 'Rejected'),
(35, 12, 7777777777, '2025-11-09', '2025-11-10', 'Approved'),
(36, 17, 663150, '2025-11-09', '2025-11-10', 'Rejected'),
(37, 16, 5555555555, '2025-11-10', '2025-11-11', 'Rejected'),
(38, 11, 7777777777, '2025-11-10', '2025-11-11', 'Approved'),
(39, 13, 663150, '2025-11-10', '2025-11-11', 'Rejected'),
(40, 14, 6631501, '2025-11-10', '2025-11-11', 'Rejected');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Student','Lecturer','Staff') NOT NULL,
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`, `profile_image`) VALUES
(10001, 'Staff001', '$argon2id$v=19$m=19456,t=2,p=1$EJTyu/xaCnIu8fgYtzx1Tg$l8dDGm1xlLIxKrFRKMmYG0mEDJ/7d3t8pdBl9lEzOrM', 'Staff', NULL),
(10002, 'Staff002', '$argon2id$v=19$m=19456,t=2,p=1$pB0tLnIM4hunwVb9d61oSw$Ga6XkL7bU4wlmHKwNGiaMb4AK/MuIADD132am5wuqTM', 'Staff', NULL),
(10003, 'Staff003', '$argon2id$v=19$m=19456,t=2,p=1$pB0tLnIM4hunwVb9d61oSw$Ga6XkL7bU4wlmHKwNGiaMb4AK/MuIADD132am5wuqTM', 'Staff', NULL),
(20001, 'Lec 13', '$argon2id$v=19$m=19456,t=2,p=1$b14jr5MVp/s57WXzkGmL2g$T5bZzTqsKk7uBigi1NwDYe/OyC62ziaeOHoTP93Nol4', 'Lecturer', 'https://img.freepik.com/premium-vector/friendly-teacher-pointing-blackboard-lesson_1209864-108.jpg?semt=ais_hybrid&w=740&q=80'),
(20002, 'Lecturer002', '$argon2id$v=19$m=19456,t=2,p=1$b14jr5MVp/s57WXzkGmL2g$T5bZzTqsKk7uBigi1NwDYe/OyC62ziaeOHoTP93Nol4', 'Lecturer', NULL),
(20003, 'Lecturer003', '$argon2id$v=19$m=19456,t=2,p=1$b14jr5MVp/s57WXzkGmL2g$T5bZzTqsKk7uBigi1NwDYe/OyC62ziaeOHoTP93Nol4', 'Lecturer', NULL),
(663150, 'abcd', '$argon2id$v=19$m=19456,t=2,p=1$gcThDAEjJF7OOkD3qCFqeQ$4azd+3GNs29LS1zUJpXAGIY7cpDPljZL7Elrb315YLU', 'Student', 'https://www.looper.com/img/gallery/the-untold-truth-of-the-boys-soldier-boy/l-intro-1654942881.jpg'),
(6631501, 'Homelander', '$argon2id$v=19$m=19456,t=2,p=1$ZuFaeUDVn2Yq5B7+se+pLA$UZvf9kgvA6bkio+Nkh6OgfBV3t6eckhALFotIXmW7po', 'Student', 'https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander-1014x570.jpg'),
(1234567890, 'dasddasd', '$argon2id$v=19$m=19456,t=2,p=1$3r5a/piIn1Jbc+gwJEIQNg$cUDk0BckyaRzi10i+6RfixgMMLsWxaz5yvsloHJIwEE', 'Student', 'https://th-thumbnailer.cdn-si-edu.com/IIzERjHsySQN2CVztETP6R0Jnq8=/fit-in/1200x0/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer/19/00/19000e55-a414-4fde-b790-5e5f9f4ff28b/hehuanshan-main-peak-istock-1148778056.jpg'),
(5555555555, 'gdfg', '$argon2id$v=19$m=19456,t=2,p=1$7koAeXH5fWFq0j7s8xqvrw$LzCnalPPsaolQJ2E8QsHUBSTUcLGVpaZkVB/eGprZUI', 'Student', NULL),
(6631501185, 'higjdjf', '$argon2id$v=19$m=19456,t=2,p=1$LKfFZg2ONQlTAqBT7uMkHA$YpKPLwRzJ6kc8ZStLacN7lrANbMn/u3oE2lX2yOZIPw', 'Student', NULL),
(7777777777, 'ddfgdg', '$argon2id$v=19$m=19456,t=2,p=1$dwKxtbB86SWNZGhFRu6elg$uHeEnRYKwkxcYG4PLWyW1GMGweO0dfraEOVDb/2lFwU', 'Student', 'https://i.redd.it/ilsap0rwt9qb1.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`asset_id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`his_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `fk_history_asset` (`asset_id`),
  ADD KEY `fk_history_user` (`user_id`),
  ADD KEY `fk_history_approver` (`approver_id`),
  ADD KEY `fk_history_staff` (`staff_id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`req_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assets`
--
ALTER TABLE `assets`
  MODIFY `asset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `his_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `req_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `fk_history_approver` FOREIGN KEY (`approver_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_history_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_history_staff` FOREIGN KEY (`staff_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
