insert into Persons
  values (733, N'Майданникова', N'Светлана', N'Юрьевна', N'19640415', N'037647E0-848C-11E5-826D-0862662BE66D')

insert into Persons
  values (6975, N'Берюхов', N'Андрей', N'Викторович', N'19831025', N'EC5AE717-848B-11E5-826D-0862662BE66D')

    insert into dbo.Subkonto (Id, Name, Discriminator)
  values (N'betpoint', N'Пункт приема ставок', N'BetPointSubkonto')

  insert into dbo.Subkonto (Id, Name, Discriminator)
  values (N'person', N'Сотрудники', N'PersonSubkonto')


    insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (50, N'50', N'Касса', null, null, N'ActiveAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (5002, N'50.02', N'Касса ОП', 50, N'betpoint', N'ActiveAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (71, N'71', N'Расчеты с подотчетными лицами', null, N'person', N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (7101, N'71.01', N'Сотрудники', 71, N'person', N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (71011, N'71.01.1', N'Подотчетные средства', 7101, N'person', N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (71012, N'71.01.2', N'Разменный фонд', 7101, N'person', N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (76, N'76', N'Расчёты с разными дебиторами и кредиторами', null, null, N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (7608, N'76.08', N'Услуги', 76, null, N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (76082, N'76.08.2', N'Услуги по ККМ', 7608, null, N'NominalAccount')

  insert into dbo.Accounts (Id, Code, Name, ParentId, Subkonto1Id, Discriminator) 
  values (5701, N'57.01', N'Переводы в пути', null, null, N'NominalAccount')