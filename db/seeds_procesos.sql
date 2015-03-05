-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 09-10-2013 a las 13:06:49
-- Versión del servidor: 5.5.32
-- Versión de PHP: 5.3.10-1ubuntu3.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `tecniflex_bak`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupoprocs`
--

CREATE TABLE IF NOT EXISTS `grupoprocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `abreviacion` varchar(255) DEFAULT NULL,
  `descripcion` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tablero` tinyint(1) DEFAULT NULL,
  `asignar` tinyint(1) DEFAULT NULL,
  `saevb` tinyint(1) DEFAULT NULL,
  `saemtz` tinyint(1) DEFAULT NULL,
  `saemtje` tinyint(1) DEFAULT NULL,
  `saeptr` tinyint(1) DEFAULT NULL,
  `saepol` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Volcado de datos para la tabla `grupoprocs`
--

INSERT INTO `grupoprocs` (`id`, `position`, `nombre`, `abreviacion`, `descripcion`, `created_at`, `updated_at`, `tablero`, `asignar`, `saevb`, `saemtz`, `saemtje`, `saeptr`, `saepol`) VALUES
(1, 1, 'Visto Bueno', 'visto', '', '2011-12-12 23:06:13', '2012-03-16 23:53:27', 1, 1, 1, 0, 0, 0, NULL),
(2, 4, 'Matriceria', 'mtz', '', '2011-12-12 23:07:31', '2013-02-21 23:17:25', 1, 1, 0, 1, 0, 0, NULL),
(3, 3, 'Printer', 'ptr', '', '2011-12-12 23:08:01', '2013-02-21 23:17:25', 1, 1, 0, 0, 0, 1, NULL),
(4, 6, 'Revision', 'rev', '', '2011-12-12 23:09:11', '2013-02-21 23:17:26', 1, 1, 0, 1, 0, 0, NULL),
(5, 5, 'Montaje', 'mtje', '', '2011-12-12 23:09:25', '2013-02-21 23:17:26', 1, 1, 0, 0, 1, 0, NULL),
(6, 7, 'Polimero', 'pol', '', '2011-12-12 23:09:38', '2013-04-04 01:06:42', 1, 0, 0, 0, 1, 0, 1),
(7, 8, 'Despacho', 'desp', '', '2011-12-12 23:09:46', '2013-02-21 23:17:26', 1, 0, 0, 0, 1, 0, NULL),
(8, 2, 'RevisionVB', '', '', '2013-02-21 23:17:19', '2013-08-30 00:51:57', 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos`
--

CREATE TABLE IF NOT EXISTS `procesos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `descripcion` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sucesor_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `grupoproc_id` int(11) DEFAULT NULL,
  `prueba` tinyint(1) DEFAULT NULL,
  `reinit` tinyint(1) DEFAULT NULL,
  `edmeds` tinyint(1) DEFAULT NULL,
  `varev` tinyint(1) DEFAULT NULL,
  `rev` tinyint(1) DEFAULT NULL,
  `destderev` tinyint(1) DEFAULT NULL,
  `factura` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_procesos_on_sucesor_id` (`sucesor_id`),
  KEY `index_procesos_on_grupoproc_id` (`grupoproc_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Volcado de datos para la tabla `procesos`
--

INSERT INTO `procesos` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`, `sucesor_id`, `position`, `grupoproc_id`, `prueba`, `reinit`, `edmeds`, `varev`, `rev`, `destderev`, `factura`) VALUES
(2, 'VistoBueno', 'Preparación y visto Bueno', '2011-07-26 02:32:20', '2012-06-08 02:45:27', 3, 1, 1, 1, 0, 0, 0, 0, 1, 0),
(3, 'Printer', '', '2011-07-26 02:32:34', '2013-02-21 23:11:23', NULL, 3, 3, 1, 1, NULL, NULL, NULL, NULL, 0),
(4, 'Matriceria', '', '2011-07-26 02:33:09', '2013-02-21 23:11:23', NULL, 4, 2, 0, 0, 0, 0, 0, 1, 0),
(5, 'Montaje', '', '2011-07-26 02:33:19', '2013-02-21 23:11:13', 14, 5, 5, 0, 0, 1, 0, 0, 1, 0),
(7, 'Polimero', '', '2011-07-26 02:33:39', '2013-02-21 23:11:13', 12, 7, 6, 0, 0, 1, 1, 0, 0, 0),
(12, 'Facturacion', '', '2011-11-23 22:09:24', '2013-05-08 00:36:06', NULL, 8, 7, 0, 0, 0, 1, 0, 0, 1),
(14, 'RevisionMM', 'Revision Matriceria y Montaje', '2011-12-16 22:35:54', '2013-02-21 23:11:13', NULL, 6, 4, 0, 0, 0, 0, 1, 0, 0),
(16, 'RevisionVB', 'Revision de Visto Bueno', '2013-02-21 23:11:06', '2013-08-30 00:09:59', 4, 2, 8, 0, 1, 0, 0, 1, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
