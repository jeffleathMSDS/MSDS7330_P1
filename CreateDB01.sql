CREATE DATABASE `illumina01` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
CREATE TABLE `authors` (
  `idAuthors` int(11) NOT NULL,
  `Author_USERName` varchar(45) DEFAULT NULL,
  `SourceID` varchar(45) DEFAULT NULL,
  `Author_Email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idAuthors`),
  KEY `SourceID_idx` (`SourceID`),
  CONSTRAINT `SourceID` FOREIGN KEY (`SourceID`) REFERENCES `datasource` (`SourceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Authors of the comment	';

CREATE TABLE `datasource` (
  `SourceID` varchar(45) NOT NULL,
  `SourceName` varchar(45) DEFAULT NULL,
  `WebAddress01` varchar(45) DEFAULT NULL,
  `WebAddress02` varchar(45) DEFAULT NULL,
  `Feature01` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`SourceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Reference of sources for scraping data from the internet';
CREATE TABLE `product` (
  `idProduct` int(11) NOT NULL,
  `ProductName` varchar(45) DEFAULT NULL,
  `Feature01` varchar(45) DEFAULT NULL,
  `Feature02` varchar(45) DEFAULT NULL,
  `Metric01` int(11) DEFAULT NULL,
  `Metric02` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProduct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Product Master for Illumina SKUs	';
CREATE TABLE `text` (
  `idText` int(11) NOT NULL,
  `Text` varchar(500) DEFAULT NULL,
  `PostDate` datetime DEFAULT NULL,
  `idAuthors` int(11) DEFAULT NULL,
  `Comment01` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`idText`),
  KEY `idAuthors_idx` (`idAuthors`),
  CONSTRAINT `idAuthors` FOREIGN KEY (`idAuthors`) REFERENCES `authors` (`idAuthors`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Text that is scrappted';
CREATE DATABASE `illumina01` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
