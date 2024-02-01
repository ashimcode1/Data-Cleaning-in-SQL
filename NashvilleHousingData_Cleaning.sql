--viewing the table data

select * from [Portfolio Project]..NashvilleHousing

-- Updating dates
select SaleDate,SaleDateConverted
from [Portfolio Project]..NashvilleHousing

update NashvilleHousing
Set SaleDate=Convert(Date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
Set SaleDateConverted=Convert(Date,SaleDate)

-- Populating Property Address Data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.ParcelID=b.ParcelID

UPDATE a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a join
[Portfolio Project]..NashvilleHousing b on
a.ParcelID=b.ParcelID and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- Address,City,State

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from [Portfolio Project]..NashvilleHousing

-- adding these into a table

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select PropertySplitAddress,PropertySplitCity 
from [Portfolio Project]..NashvilleHousing

-- seperating address,city using parsename
Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState= Parsename(Replace(OwnerAddress,',','.'),1)

Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


-- Change Y and S to Yes and NO in 'Sold As Vacant' field

Update NashvilleHousing
set SoldAsVacant= Case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant ='N' then 'No'
	else SoldAsVacant
	End

-- Removing Duplicates
With RowNumCTE As(
SELECT *,ROW_NUMBER() OVER (PARTITION BY [ParcelId], [PropertyAddress], [SalePrice], [SaleDate], [LegalReference]
ORDER BY UniqueId) rownum
FROM [Portfolio Project]..NashvilleHousing
)
Select * from RowNumCTE
where rownum>1

-- Delete unused Columns

select *
from Portfolio Project..Nashvillehousing

Alter Table [Portfolio Project]..NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress	




