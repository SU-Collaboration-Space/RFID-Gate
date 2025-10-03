-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 03, 2025 at 01:04 PM
-- Server version: 10.11.14-MariaDB-0+deb12u2
-- PHP Version: 8.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs_rfid_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `cs_equipment`
--

CREATE TABLE `cs_equipment` (
  `id` int(11) NOT NULL,
  `assigned_rfid` varchar(50) NOT NULL,
  `equipment_name` varchar(100) DEFAULT NULL,
  `allowed_to_leave` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cs_equipment`
--

INSERT INTO `cs_equipment` (`id`, `assigned_rfid`, `equipment_name`, `allowed_to_leave`) VALUES
(1, '1100EE00A1A2A3A4A5A6A7A8A9B1B2B3A02D', 'Artec Space Spider', 0),
(2, '1100EE0011223344556677886C1ABBCC7F82', 'Sony alpha 9', 1);

-- --------------------------------------------------------

--
-- Table structure for table `rfid_logs`
--

CREATE TABLE `rfid_logs` (
  `id` int(11) NOT NULL,
  `rfid_tag` varchar(255) NOT NULL,
  `is_allowed` tinyint(1) NOT NULL,
  `check_time` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cs_equipment`
--
ALTER TABLE `cs_equipment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `assigned_rfid` (`assigned_rfid`);

--
-- Indexes for table `rfid_logs`
--
ALTER TABLE `rfid_logs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cs_equipment`
--
ALTER TABLE `cs_equipment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rfid_logs`
--
ALTER TABLE `rfid_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
