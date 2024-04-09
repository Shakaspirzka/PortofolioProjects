-- Cleaning Data in Sql Queries

Select *
From PortofolioProject.dbo.NashvilleHousing 


-- Standardize Date Format

 Select SaleDate, CONVERT(Date,SaleDate)
From PortofolioProject.dbo.NashvilleHousing 
  
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate) 

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Population Property Address data , fill out responses where possible ( entries with the same ParcelID should share the same adress) using the ISNULL com

SELECT *
FROM PortofolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM PortofolioProject.dbo.NashvilleHousing a
JOIN PortofolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]  
WHERE a.PropertyAddress is null

Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject.dbo.NashvilleHousing a
JOIN PortofolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]  
WHERE a.PropertyAddress is null


--Breaking out Address into Individual Columns (Adress, City, State) 

SELECT PropertyAddress
FROM PortofolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--order by ParcelID

SELECT  
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address


FROM PortofolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)


ALTER TABLE NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

 Select *
 From PortofolioProject.dbo.NashvilleHousing  



 Select OwnerAddress
 From PortofolioProject.dbo.NashvilleHousing
 
 -- PARSENAME looks for periods not commas

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

FROM PortofolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)



-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortofolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
  From PortofolioProject.dbo.NashvilleHousing


  Update NashvilleHousing
  SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END


	 


-- Remove Duplicates
  
  WITH RowNumCTE AS(
  Select *,
         ROW_NUMBER() OVER (
		 PARTITION BY ParcelID,
		              PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  ORDER BY
					      UniqueID
		                    ) row_num
  From PortofolioProject.dbo.NashvilleHousing
  --order by ParcelID
  )
  Select* 
  FROM RowNumCTE
  Where row_num >1
   
   -- 
  --WITH RowNumCTE AS(
  --Select *,
  --       ROW_NUMBER() OVER (
		-- PARTITION BY ParcelID,
		--              PropertyAddress,
		--			  SalePrice,
		--			  SaleDate,
		--			  LegalReference
		--			  ORDER BY
		--			      UniqueID
		--                    ) row_num
  --From PortofolioProject.dbo.NashvilleHousing
  --order by ParcelID
  --)
  --Delete (!!!!)
  --FROM RowNumCTE
  --Where row_num >1

  SELECT*
    From PortofolioProject.dbo.NashvilleHousing






-- Delete Unused Columns

 SELECT*
 From PortofolioProject.dbo.NashvilleHousing


 ALTER TABLE PortofolioProject.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 
 ALTER TABLE PortofolioProject.dbo.NashvilleHousing
 DROP COLUMN SaleDate





