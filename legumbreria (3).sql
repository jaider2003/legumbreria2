-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-04-2025 a las 21:45:04
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `legumbreria`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `precio_promedio_productos` () RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(precio) INTO promedio FROM productos;
    
    RETURN IFNULL(promedio, 0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_compras_cliente` (`cliente_id` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(total) INTO total FROM ventas WHERE id_cliente = cliente_id;
    
    RETURN IFNULL(total, 0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_compras_proveedor` (`id_proveedor` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(total) INTO total
    FROM registro_compras
    WHERE registro_compras.id_proveedor = id_proveedor;
    
    RETURN IFNULL(total, 0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_gasto_cliente` (`id_cliente` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(total) INTO total
    FROM ventas
    WHERE ventas.id_cliente = id_cliente;
    
    RETURN IFNULL(total, 0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_stock` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;
    
    SELECT SUM(stock) INTO total FROM productos;
    
    RETURN IFNULL(total, 0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `ip_usuario` varchar(45) DEFAULT NULL,
  `accion` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditorias_de_pedidos`
--

CREATE TABLE `auditorias_de_pedidos` (
  `id_auditoria` int(11) NOT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `cambio` varchar(255) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `apellido`, `telefono`, `direccion`, `correo`) VALUES
(1, 'Juan', 'Pérez', '123456789', 'Calle 1 #23-45', 'juan.perez@email.com'),
(2, 'María', 'Gómez', '987654321', 'Carrera 2 #34-56', 'maria.gomez@email.com'),
(3, 'Carlos', 'López', '321654987', 'Avenida 3 #12-34', 'carlos.lopez@email.com'),
(4, 'Sofía', 'Díaz', '876543210', 'Calle 4 #10-11', 'sofia.diaz@email.com'),
(5, 'Ricardo', 'Torres', '765432109', 'Carrera 5 #22-33', 'ricardo.torres@email.com'),
(6, 'Laura', 'Martínez', '654321098', 'Diagonal 6 #44-55', 'laura.martinez@email.com'),
(7, 'Andrés', 'Hernández', '543210987', 'Calle 7 #66-77', 'andres.hernandez@email.com'),
(8, 'Valeria', 'Fernández', '432109876', 'Carrera 8 #88-99', 'valeria.fernandez@email.com'),
(9, 'Miguel', 'Ortega', '321098765', 'Avenida 9 #12-23', 'miguel.ortega@email.com'),
(10, 'Paula', 'Castro', '210987654', 'Transversal 10 #34-45', 'paula.castro@email.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_compras`
--

CREATE TABLE `detalles_compras` (
  `id_detalle` int(11) NOT NULL,
  `id_compra` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalles_compras`
--

INSERT INTO `detalles_compras` (`id_detalle`, `id_compra`, `id_producto`, `cantidad`, `precio_compra`, `subtotal`) VALUES
(1, 1, 1, 10, 3000.00, 30000.00),
(2, 2, 3, 5, 5000.00, 25000.00),
(3, 3, 5, 7, 7000.00, 35000.00),
(4, 4, 7, 8, 10000.00, 40000.00),
(5, 5, 9, 6, 5000.00, 28000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_ventas`
--

CREATE TABLE `detalles_ventas` (
  `id_detalle` int(11) NOT NULL,
  `id_venta` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalles_ventas`
--

INSERT INTO `detalles_ventas` (`id_detalle`, `id_venta`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 2, 5000.00, 10000.00),
(2, 1, 2, 1, 5000.00, 5000.00),
(3, 2, 3, 2, 5500.00, 11000.00),
(4, 3, 4, 3, 5000.00, 15000.00),
(5, 4, 5, 1, 7000.00, 7000.00),
(6, 6, 1, 3, 5000.00, 15000.00),
(7, 6, 3, 2, 5500.00, 11000.00);

--
-- Disparadores `detalles_ventas`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_despues_venta` AFTER INSERT ON `detalles_ventas` FOR EACH ROW BEGIN
    UPDATE productos 
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `evitar_venta_sin_stock` BEFORE INSERT ON `detalles_ventas` FOR EACH ROW BEGIN
    DECLARE stock_actual INT;
    
    -- Obtener stock actual del producto
    SELECT stock INTO stock_actual
    FROM productos
    WHERE id_producto = NEW.id_producto;
    
    -- Si el stock es insuficiente, genera un error
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para esta venta';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reducir_stock_venta` AFTER INSERT ON `detalles_ventas` FOR EACH ROW BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_stock_antes_venta` BEFORE INSERT ON `detalles_ventas` FOR EACH ROW BEGIN
    DECLARE stock_actual INT;
    
    -- Obtener el stock del producto
    SELECT stock INTO stock_actual FROM productos WHERE id_producto = NEW.id_producto;
    
    -- Verificar si hay suficiente stock
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No hay suficiente stock disponible para este producto.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `salario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `nombre`, `apellido`, `telefono`, `cargo`, `salario`) VALUES
(1, 'Pedro', 'Martínez', '555123456', 'Cajero', 1200000.00),
(2, 'Ana', 'Rodríguez', '555654321', 'Vendedor', 1300000.00),
(3, 'Luis', 'García', '555987654', 'Administrador', 2000000.00),
(4, 'Diana', 'Jiménez', '555246813', 'Cajero', 1250000.00),
(5, 'Miguel', 'Ortega', '555369147', 'Vendedor', 1350000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_sesiones`
--

CREATE TABLE `logs_sesiones` (
  `id_log` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `estado` enum('pendiente','enviado','cancelado') NOT NULL DEFAULT 'pendiente',
  `total` decimal(10,2) DEFAULT 0.00,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `direccion_ip` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `estado` enum('Bueno','Malo','Regular') NOT NULL DEFAULT 'Bueno',
  `id_proveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `categoria`, `precio`, `stock`, `estado`, `id_proveedor`) VALUES
(1, 'Lentejas', 'Legumbres', 5000.00, 94, 'Bueno', 1),
(2, 'Frijoles', 'Legumbres', 6000.00, 80, 'Bueno', 1),
(3, 'Garbanzos', 'Legumbres', 5500.00, 46, 'Regular', 2),
(4, 'Arvejas', 'Legumbres', 5000.00, 57, 'Malo', 3),
(5, 'Habas', 'Legumbres', 7000.00, 39, 'Bueno', 2),
(6, 'Maíz', 'Cereales', 4000.00, 90, 'Regular', 4),
(7, 'Quinua', 'Cereales', 12000.00, 30, 'Bueno', 3),
(8, 'Chía', 'Semillas', 15000.00, 20, 'Malo', 4),
(9, 'Linaza', 'Semillas', 9000.00, 50, 'Regular', 5),
(10, 'Soya', 'Legumbres', 6500.00, 70, 'Bueno', 1);

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `auditoria_productos` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    DECLARE v_ip VARCHAR(45);
    DECLARE v_usuario INT;
    -- Aquí deberías definir cómo obtienes el id_usuario e IP

    INSERT INTO auditoria (id_usuario, ip_usuario, accion)
    VALUES (v_usuario, v_ip, CONCAT('Actualización de stock en producto ID: ', OLD.id_producto));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `registrar_cambio_precio` BEFORE UPDATE ON `productos` FOR EACH ROW BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO historial_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES (OLD.id_producto, OLD.precio, NEW.precio, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nombre`, `telefono`, `direccion`, `correo`) VALUES
(1, 'Proveedor A', '111222333', 'Zona Industrial 1', 'contacto@proveedora.com'),
(2, 'Proveedor B', '444555666', 'Zona Comercial 2', 'contacto@proveedorb.com'),
(3, 'Proveedor C', '777888999', 'Zona Industrial 3', 'contacto@proveedorc.com'),
(4, 'Proveedor D', '222333444', 'Zona Comercial 4', 'contacto@proveedord.com'),
(5, 'Proveedor E', '555666777', 'Zona Rural 5', 'contacto@proveedore.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_compras`
--

CREATE TABLE `registro_compras` (
  `id_compra` int(11) NOT NULL,
  `fecha_compra` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_proveedor` int(11) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro_compras`
--

INSERT INTO `registro_compras` (`id_compra`, `fecha_compra`, `id_proveedor`, `id_empleado`, `total`) VALUES
(1, '2025-03-26 03:18:42', 1, 1, 30000.00),
(2, '2025-03-26 03:18:42', 2, 2, 25000.00),
(3, '2025-03-26 03:29:32', 3, 3, 35000.00),
(4, '2025-03-26 03:29:32', 4, 4, 40000.00),
(5, '2025-03-26 03:29:32', 5, 5, 28000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Vendedor'),
(3, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `id_rol` int(11) NOT NULL,
  `id_permiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `intentos_fallidos` int(11) DEFAULT 0,
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `usuario`, `correo`, `contrasena`, `id_rol`, `intentos_fallidos`, `estado`) VALUES
(1, 'admin', 'admin@correo.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 1, 0, 'Activo'),
(2, 'vendedor1', 'vendedor1@correo.com', 'bc431c22f966ff587d08bec8f58b97425d05c402e54c9052888b3a3ab1b7f7a3', 2, 0, 'Activo'),
(3, 'cliente1', 'cliente1@correo.com', '09a31a7001e261ab1e056182a71d3cf57f582ca9a29cff5eb83be0f0549730a9', 3, 0, 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `fecha_venta` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_cliente` int(11) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `fecha_venta`, `id_cliente`, `id_empleado`, `total`) VALUES
(1, '2025-03-26 03:18:42', 1, 1, 15000.00),
(2, '2025-03-26 03:18:42', 2, 2, 12000.00),
(3, '2025-03-26 03:28:47', 3, 3, 18000.00),
(4, '2025-03-26 03:28:47', 4, 4, 25000.00),
(5, '2025-03-26 03:28:47', 5, 5, 14000.00),
(6, '2025-03-26 03:33:21', 1, 1, 25000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_auditoria_resumen`
--

CREATE TABLE `vista_auditoria_resumen` (
  `id_auditoria` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `ip_usuario` varchar(45) DEFAULT NULL,
  `accion` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_clientes_frecuentes`
--

CREATE TABLE `vista_clientes_frecuentes` (
  `id_cliente` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `cantidad_compras` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_compras_recientes`
--

CREATE TABLE `vista_compras_recientes` (
  `id_compra` int(11) DEFAULT NULL,
  `fecha_compra` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `proveedor` varchar(100) DEFAULT NULL,
  `empleado` varchar(100) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_empleados_mayor_venta`
--

CREATE TABLE `vista_empleados_mayor_venta` (
  `id_empleado` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `cantidad_ventas` bigint(21) DEFAULT NULL,
  `total_vendido` decimal(32,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_productos_bajo_stock`
--

CREATE TABLE `vista_productos_bajo_stock` (
  `id_producto` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `estado` enum('Bueno','Malo','Regular') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_productos_mas_vendidos`
--

CREATE TABLE `vista_productos_mas_vendidos` (
  `id_producto` int(11) DEFAULT NULL,
  `producto` varchar(100) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `total_vendido` decimal(32,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_proveedores_productos`
--

CREATE TABLE `vista_proveedores_productos` (
  `id_proveedor` int(11) DEFAULT NULL,
  `proveedor` varchar(100) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `producto` varchar(100) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_ventas_por_cliente`
--

CREATE TABLE `vista_ventas_por_cliente` (
  `id_cliente` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `total_ventas` bigint(21) DEFAULT NULL,
  `monto_total` decimal(32,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
