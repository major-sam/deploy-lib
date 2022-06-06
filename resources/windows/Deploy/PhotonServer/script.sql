USE [master]
GO
/****** Object:  Database [Photon_Gambling]    Script Date: 5/17/2022 2:42:46 PM ******/
CREATE DATABASE [Photon_Gambling]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Gambling', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Photon_Gambling.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Gambling_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Photon_Gambling_log.ldf' , SIZE = 2560KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Photon_Gambling] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Photon_Gambling].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Photon_Gambling] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Photon_Gambling] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Photon_Gambling] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Photon_Gambling] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Photon_Gambling] SET ARITHABORT OFF 
GO
ALTER DATABASE [Photon_Gambling] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Photon_Gambling] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Photon_Gambling] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Photon_Gambling] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Photon_Gambling] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Photon_Gambling] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Photon_Gambling] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Photon_Gambling] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Photon_Gambling] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Photon_Gambling] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Photon_Gambling] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Photon_Gambling] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Photon_Gambling] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Photon_Gambling] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Photon_Gambling] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Photon_Gambling] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Photon_Gambling] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Photon_Gambling] SET RECOVERY FULL 
GO
ALTER DATABASE [Photon_Gambling] SET  MULTI_USER 
GO
ALTER DATABASE [Photon_Gambling] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Photon_Gambling] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Photon_Gambling] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Photon_Gambling] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Photon_Gambling] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Photon_Gambling] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Photon_Gambling', N'ON'
GO
ALTER DATABASE [Photon_Gambling] SET QUERY_STORE = OFF
GO
USE [Photon_Gambling]
GO
/****** Object:  Schema [Dice]    Script Date: 5/17/2022 2:42:46 PM ******/
CREATE SCHEMA [Dice]
GO
/****** Object:  Schema [Slot]    Script Date: 5/17/2022 2:42:46 PM ******/
CREATE SCHEMA [Slot]
GO
/****** Object:  Table [dbo].[Test]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test](
	[Id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[BetSequences]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[BetSequences](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[value] [decimal](6, 2) NULL,
 CONSTRAINT [PK_BetSequences] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[BonusGameCoefficient]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[BonusGameCoefficient](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SlotsId] [int] NOT NULL,
	[CountScatter] [int] NOT NULL,
	[MinRangeValue] [int] NOT NULL,
	[MaxRangeValue] [int] NOT NULL,
	[Coef] [int] NOT NULL,
 CONSTRAINT [PK_BonusGameCoefficient] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[DrumMachine]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[DrumMachine](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MachineId] [int] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[DrumIndex] [int] NOT NULL,
	[SymbolId] [int] NOT NULL,
 CONSTRAINT [PK_DrumMachine] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[Machine]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[Machine](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
 CONSTRAINT [PK_Machine] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[MachineSlots]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[MachineSlots](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SlotId] [int] NOT NULL,
	[MachineId] [int] NOT NULL,
 CONSTRAINT [PK_Slot.MachineSlots] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[PayTable]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[PayTable](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SlotsId] [int] NOT NULL,
	[SymbolsId] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_Slot.PayTable] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[SlotMachines]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[SlotMachines](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Slots_Id] [int] NOT NULL,
	[Machine_Id] [int] NOT NULL,
 CONSTRAINT [PK_Slot.SlotToMachine] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[Slots]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[Slots](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Slot.Slots] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Slot].[Symbols]    Script Date: 5/17/2022 2:42:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Slot].[Symbols](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Hash] [int] NULL,
	[Cost] [int] NULL,
 CONSTRAINT [PK_Slot.Symbols] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [Slot].[BetSequences] ON 

INSERT [Slot].[BetSequences] ([id], [value]) VALUES (1, CAST(0.10 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (2, CAST(0.20 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (3, CAST(0.50 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (4, CAST(1.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (5, CAST(2.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (6, CAST(5.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (7, CAST(10.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (8, CAST(20.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (9, CAST(50.00 AS Decimal(6, 2)))
INSERT [Slot].[BetSequences] ([id], [value]) VALUES (10, CAST(100.00 AS Decimal(6, 2)))
SET IDENTITY_INSERT [Slot].[BetSequences] OFF
GO
SET IDENTITY_INSERT [Slot].[BonusGameCoefficient] ON 

INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (1, 1, 4, 1, 400, 0)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (2, 1, 4, 401, 650, 5)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (3, 1, 4, 651, 800, 10)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (4, 1, 4, 801, 900, 20)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (5, 1, 4, 901, 960, 30)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (6, 1, 4, 961, 1000, 50)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (7, 1, 4, 1001, 1020, 100)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (9, 1, 4, 1021, 1021, 1000)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (10, 1, 5, 1, 400, 0)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (11, 1, 5, 401, 650, 250)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (12, 1, 5, 651, 800, 400)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (13, 1, 5, 801, 900, 500)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (14, 1, 5, 901, 960, 1000)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (15, 1, 5, 961, 1000, 1500)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (16, 1, 5, 1001, 1020, 2000)
INSERT [Slot].[BonusGameCoefficient] ([id], [SlotsId], [CountScatter], [MinRangeValue], [MaxRangeValue], [Coef]) VALUES (17, 1, 5, 1021, 1021, 10000)
SET IDENTITY_INSERT [Slot].[BonusGameCoefficient] OFF
GO
SET IDENTITY_INSERT [Slot].[DrumMachine] ON 

INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (601, 1, 1, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (602, 1, 1, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (603, 1, 1, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (604, 1, 1, 4, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (605, 1, 1, 5, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (606, 1, 2, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (607, 1, 2, 2, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (608, 1, 2, 3, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (609, 1, 2, 4, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (610, 1, 2, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (611, 1, 3, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (612, 1, 3, 2, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (613, 1, 3, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (614, 1, 3, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (615, 1, 3, 5, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (616, 1, 4, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (617, 1, 4, 2, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (618, 1, 4, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (619, 1, 4, 4, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (620, 1, 4, 5, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (621, 1, 5, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (622, 1, 5, 2, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (623, 1, 5, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (624, 1, 5, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (625, 1, 5, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (626, 1, 6, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (627, 1, 6, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (628, 1, 6, 3, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (629, 1, 6, 4, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (630, 1, 6, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (631, 1, 7, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (632, 1, 7, 2, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (633, 1, 7, 3, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (634, 1, 7, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (635, 1, 7, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (636, 1, 8, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (637, 1, 8, 2, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (638, 1, 8, 3, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (639, 1, 8, 4, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (640, 1, 8, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (641, 1, 9, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (642, 1, 9, 2, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (643, 1, 9, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (644, 1, 9, 4, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (645, 1, 9, 5, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (646, 1, 10, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (647, 1, 10, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (648, 1, 10, 3, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (649, 1, 10, 4, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (650, 1, 10, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (651, 1, 11, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (652, 1, 11, 2, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (653, 1, 11, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (654, 1, 11, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (655, 1, 11, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (656, 1, 12, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (657, 1, 12, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (658, 1, 12, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (659, 1, 12, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (660, 1, 12, 5, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (661, 1, 13, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (662, 1, 13, 2, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (663, 1, 13, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (664, 1, 13, 4, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (665, 1, 13, 5, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (666, 1, 14, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (667, 1, 14, 2, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (668, 1, 14, 3, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (669, 1, 14, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (670, 1, 14, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (671, 1, 15, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (672, 1, 15, 2, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (673, 1, 15, 3, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (674, 1, 15, 4, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (675, 1, 15, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (676, 1, 16, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (677, 1, 16, 2, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (678, 1, 16, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (679, 1, 16, 4, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (680, 1, 16, 5, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (681, 1, 17, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (682, 1, 17, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (683, 1, 17, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (684, 1, 17, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (685, 1, 17, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (686, 1, 18, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (687, 1, 18, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (688, 1, 18, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (689, 1, 18, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (690, 1, 18, 5, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (691, 1, 19, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (692, 1, 19, 2, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (693, 1, 19, 3, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (694, 1, 19, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (695, 1, 19, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (696, 1, 20, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (697, 1, 20, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (698, 1, 20, 3, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (699, 1, 20, 4, 6)
GO
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (700, 1, 20, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (701, 1, 21, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (702, 1, 21, 2, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (703, 1, 21, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (704, 1, 21, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (705, 1, 21, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (706, 1, 22, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (707, 1, 22, 2, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (708, 1, 22, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (709, 1, 22, 4, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (710, 1, 22, 5, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (711, 1, 23, 1, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (712, 1, 23, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (713, 1, 23, 3, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (714, 1, 23, 4, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (715, 1, 23, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (716, 1, 24, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (717, 1, 24, 2, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (718, 1, 24, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (719, 1, 24, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (720, 1, 24, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (721, 1, 25, 1, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (722, 1, 25, 2, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (723, 1, 25, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (724, 1, 25, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (725, 1, 25, 5, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (726, 1, 26, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (727, 1, 26, 2, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (728, 1, 26, 3, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (729, 1, 26, 4, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (730, 1, 26, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (731, 1, 27, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (732, 1, 27, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (733, 1, 27, 3, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (734, 1, 27, 4, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (735, 1, 27, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (736, 1, 28, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (737, 1, 28, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (738, 1, 28, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (739, 1, 28, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (740, 1, 28, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (741, 1, 29, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (742, 1, 29, 2, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (743, 1, 29, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (744, 1, 29, 4, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (745, 1, 29, 5, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (746, 1, 30, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (747, 1, 30, 2, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (748, 1, 30, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (749, 1, 30, 4, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (750, 1, 30, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (751, 1, 31, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (752, 1, 31, 2, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (753, 1, 31, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (754, 1, 31, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (755, 1, 31, 5, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (756, 1, 32, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (757, 1, 32, 2, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (758, 1, 32, 3, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (759, 1, 32, 4, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (760, 1, 32, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (761, 1, 33, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (762, 1, 33, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (763, 1, 33, 3, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (764, 1, 33, 4, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (765, 1, 33, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (766, 1, 34, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (767, 1, 34, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (768, 1, 34, 3, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (769, 1, 34, 4, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (770, 1, 34, 5, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (771, 1, 35, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (772, 1, 35, 2, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (773, 1, 35, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (774, 1, 35, 4, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (775, 1, 35, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (776, 1, 36, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (777, 1, 36, 2, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (778, 1, 36, 3, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (779, 1, 36, 4, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (780, 1, 36, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (781, 1, 37, 1, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (782, 1, 37, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (783, 1, 37, 3, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (784, 1, 37, 4, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (785, 1, 37, 5, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (786, 1, 38, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (787, 1, 38, 2, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (788, 1, 38, 3, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (789, 1, 38, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (790, 1, 38, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (791, 1, 39, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (792, 1, 39, 2, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (793, 1, 39, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (794, 1, 39, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (795, 1, 39, 5, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (796, 1, 40, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (797, 1, 40, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (798, 1, 40, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (799, 1, 40, 4, 2)
GO
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (800, 1, 40, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (801, 1, 41, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (802, 1, 41, 2, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (803, 1, 41, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (804, 1, 41, 4, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (805, 1, 41, 5, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (806, 1, 42, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (807, 1, 42, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (808, 1, 42, 3, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (809, 1, 42, 4, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (810, 1, 42, 5, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (811, 1, 43, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (812, 1, 43, 2, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (813, 1, 43, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (814, 1, 43, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (815, 1, 43, 5, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (816, 1, 44, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (817, 1, 44, 2, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (818, 1, 44, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (819, 1, 44, 4, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (820, 1, 44, 5, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (821, 1, 45, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (822, 1, 45, 2, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (823, 1, 45, 3, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (824, 1, 45, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (825, 1, 45, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (826, 1, 46, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (827, 1, 46, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (828, 1, 46, 3, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (829, 1, 46, 4, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (830, 1, 46, 5, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (831, 1, 47, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (832, 1, 47, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (833, 1, 47, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (834, 1, 47, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (835, 1, 47, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (836, 1, 48, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (837, 1, 48, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (838, 1, 48, 3, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (839, 1, 48, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (840, 1, 48, 5, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (841, 1, 49, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (842, 1, 49, 2, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (843, 1, 49, 3, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (844, 1, 49, 4, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (845, 1, 49, 5, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (846, 1, 50, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (847, 1, 50, 2, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (848, 1, 50, 3, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (849, 1, 50, 4, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (850, 1, 50, 5, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (851, 1, 51, 1, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (852, 1, 51, 2, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (853, 1, 51, 3, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (854, 1, 51, 4, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (855, 1, 51, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (856, 1, 52, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (857, 1, 52, 2, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (858, 1, 52, 3, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (859, 1, 52, 4, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (860, 1, 52, 5, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (861, 1, 53, 1, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (862, 1, 53, 2, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (863, 1, 53, 3, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (864, 1, 53, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (865, 1, 53, 5, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (866, 1, 54, 1, 1)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (867, 1, 54, 2, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (868, 1, 54, 3, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (869, 1, 54, 4, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (870, 1, 54, 5, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (871, 1, 55, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (872, 1, 55, 3, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (873, 1, 55, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (874, 1, 55, 5, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (875, 1, 56, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (876, 1, 56, 4, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (877, 1, 56, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (878, 1, 57, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (879, 1, 57, 4, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (880, 1, 57, 5, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (881, 1, 58, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (882, 1, 58, 4, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (883, 1, 58, 5, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (884, 1, 59, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (885, 1, 59, 4, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (886, 1, 59, 5, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (887, 1, 60, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (888, 1, 60, 4, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (889, 1, 60, 5, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (890, 1, 61, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (891, 1, 61, 4, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (892, 1, 62, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (893, 1, 63, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (894, 1, 64, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (895, 1, 65, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (896, 1, 66, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (897, 1, 67, 1, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (898, 1, 68, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (899, 1, 69, 1, 10)
GO
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (900, 1, 70, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (901, 1, 71, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (902, 1, 72, 1, 2)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (903, 1, 73, 1, 3)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (904, 1, 74, 1, 4)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (905, 1, 75, 1, 5)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (906, 1, 76, 1, 6)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (907, 1, 77, 1, 7)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (908, 1, 78, 1, 8)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (909, 1, 79, 1, 9)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (910, 1, 80, 1, 11)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (911, 1, 81, 1, 10)
INSERT [Slot].[DrumMachine] ([id], [MachineId], [RowIndex], [DrumIndex], [SymbolId]) VALUES (912, 1, 82, 1, 1)
SET IDENTITY_INSERT [Slot].[DrumMachine] OFF
GO
SET IDENTITY_INSERT [Slot].[Machine] ON 

INSERT [Slot].[Machine] ([id], [Name], [Description]) VALUES (1, N'MACHINE 1', NULL)
INSERT [Slot].[Machine] ([id], [Name], [Description]) VALUES (2, N'MACHINE 2', NULL)
SET IDENTITY_INSERT [Slot].[Machine] OFF
GO
SET IDENTITY_INSERT [Slot].[PayTable] ON 

INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (2, 1, 1, 3, 2)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (4, 1, 1, 4, 15)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (5, 1, 1, 5, 100)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (6, 1, 2, 3, 3)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (7, 1, 2, 4, 20)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (8, 1, 2, 5, 125)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (10, 1, 3, 3, 4)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (11, 1, 3, 4, 25)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (12, 1, 3, 5, 150)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (13, 1, 4, 3, 5)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (14, 1, 4, 4, 30)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (15, 1, 4, 5, 200)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (16, 1, 5, 3, 6)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (17, 1, 5, 4, 35)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (18, 1, 5, 5, 300)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (19, 1, 6, 3, 7)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (20, 1, 6, 4, 40)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (21, 1, 6, 5, 400)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (22, 1, 7, 3, 8)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (23, 1, 7, 4, 50)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (24, 1, 7, 5, 500)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (25, 1, 8, 3, 9)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (26, 1, 8, 4, 60)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (27, 1, 8, 5, 750)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (28, 1, 9, 3, 10)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (29, 1, 9, 4, 80)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (30, 1, 9, 5, 1500)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (31, 1, 11, 3, 1)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (32, 1, 11, 4, 10)
INSERT [Slot].[PayTable] ([id], [SlotsId], [SymbolsId], [Count], [Value]) VALUES (33, 1, 11, 5, 100)
SET IDENTITY_INSERT [Slot].[PayTable] OFF
GO
SET IDENTITY_INSERT [Slot].[SlotMachines] ON 

INSERT [Slot].[SlotMachines] ([id], [Slots_Id], [Machine_Id]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [Slot].[SlotMachines] OFF
GO
SET IDENTITY_INSERT [Slot].[Slots] ON 

INSERT [Slot].[Slots] ([id], [Name]) VALUES (1, N'Night City Slots')
SET IDENTITY_INSERT [Slot].[Slots] OFF
GO
SET IDENTITY_INSERT [Slot].[Symbols] ON 

INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (1, N'9', -842352745, 1)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (2, N'10', -843401329, 2)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (3, N'J', -842352666, 3)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (4, N'Q', -842352657, 4)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (5, N'K', -842352667, 5)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (6, N'A', -842352673, 6)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (7, N'P1', -843466768, 7)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (8, N'P2', -843532304, 8)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (9, N'P3', -843597840, 9)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (10, N'Wild', -326981625, -1)
INSERT [Slot].[Symbols] ([id], [Name], [Hash], [Cost]) VALUES (11, N'Scatter', 271415716, 0)
SET IDENTITY_INSERT [Slot].[Symbols] OFF
GO
/****** Object:  Index [IX_Symbols]    Script Date: 5/17/2022 2:42:46 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Symbols] ON [Slot].[Symbols]
(
	[Hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Slot].[BonusGameCoefficient]  WITH CHECK ADD  CONSTRAINT [FK_BonusGameCoefficient_Slots] FOREIGN KEY([SlotsId])
REFERENCES [Slot].[Slots] ([id])
GO
ALTER TABLE [Slot].[BonusGameCoefficient] CHECK CONSTRAINT [FK_BonusGameCoefficient_Slots]
GO
ALTER TABLE [Slot].[DrumMachine]  WITH CHECK ADD  CONSTRAINT [FK_DrumMachine_Machine] FOREIGN KEY([MachineId])
REFERENCES [Slot].[Machine] ([id])
GO
ALTER TABLE [Slot].[DrumMachine] CHECK CONSTRAINT [FK_DrumMachine_Machine]
GO
ALTER TABLE [Slot].[DrumMachine]  WITH CHECK ADD  CONSTRAINT [FK_DrumMachine_Symbols] FOREIGN KEY([SymbolId])
REFERENCES [Slot].[Symbols] ([id])
GO
ALTER TABLE [Slot].[DrumMachine] CHECK CONSTRAINT [FK_DrumMachine_Symbols]
GO
ALTER TABLE [Slot].[MachineSlots]  WITH CHECK ADD  CONSTRAINT [FK_MachineSlots_Machine] FOREIGN KEY([MachineId])
REFERENCES [Slot].[Machine] ([id])
GO
ALTER TABLE [Slot].[MachineSlots] CHECK CONSTRAINT [FK_MachineSlots_Machine]
GO
ALTER TABLE [Slot].[MachineSlots]  WITH CHECK ADD  CONSTRAINT [FK_MachineSlots_Slots] FOREIGN KEY([SlotId])
REFERENCES [Slot].[Slots] ([id])
GO
ALTER TABLE [Slot].[MachineSlots] CHECK CONSTRAINT [FK_MachineSlots_Slots]
GO
ALTER TABLE [Slot].[PayTable]  WITH CHECK ADD  CONSTRAINT [FK_PayTable_Slots] FOREIGN KEY([SlotsId])
REFERENCES [Slot].[Slots] ([id])
GO
ALTER TABLE [Slot].[PayTable] CHECK CONSTRAINT [FK_PayTable_Slots]
GO
ALTER TABLE [Slot].[PayTable]  WITH CHECK ADD  CONSTRAINT [FK_PayTable_Symbols] FOREIGN KEY([SymbolsId])
REFERENCES [Slot].[Symbols] ([id])
GO
ALTER TABLE [Slot].[PayTable] CHECK CONSTRAINT [FK_PayTable_Symbols]
GO
ALTER TABLE [Slot].[SlotMachines]  WITH CHECK ADD  CONSTRAINT [FK_SlotToMachine_Machine1] FOREIGN KEY([Machine_Id])
REFERENCES [Slot].[Machine] ([id])
GO
ALTER TABLE [Slot].[SlotMachines] CHECK CONSTRAINT [FK_SlotToMachine_Machine1]
GO
ALTER TABLE [Slot].[SlotMachines]  WITH CHECK ADD  CONSTRAINT [FK_SlotToMachine_Slots1] FOREIGN KEY([Slots_Id])
REFERENCES [Slot].[Slots] ([id])
GO
ALTER TABLE [Slot].[SlotMachines] CHECK CONSTRAINT [FK_SlotToMachine_Slots1]
GO
USE [master]
GO
ALTER DATABASE [Photon_Gambling] SET  READ_WRITE 
GO
