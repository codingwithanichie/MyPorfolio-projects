SELECT *
FROM nashvillehousing


SELECT SalesDateConverted, CONVERT(Date, SaleDate) AS SalesDateConverted2
FROM nashvillehousing;


UPDATE nashvillehousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE nashvillehousing
ADD SalesDateConverted DATE;

UPDATE nashvillehousing
SET SalesDateConverted = CONVERT(Date,SaleDate);



SELECT *
FROM nashvillehousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, a.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
join nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
join nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address
FROM nashvillehousing

ALTER TABLE nashvillehousing
ADD ProperSplitAddress nvarchar(255);

UPDATE nashvillehousing
SET ProperSplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE nashvillehousing
ADD PropertySplitCity nvarchar(255);

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));





SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM nashvillehousing


ALTER TABLE nashvillehousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


--ALTER TABLE nashvillehousing
--ADD OwnerSplitCity nvarchar(255);
ALTER TABLE nashvillehousing
ALTER COLUMN OwnerSplitCity nvarchar(255);


UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE nashvillehousing
ADD OwnerSplitState nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM nashvillehousing


UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END




WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) row_num
FROM nashvillehousing
--ORDER BY ParcelID
)
SELECT *
from RowNumCTE
where row_num > 1
order by PropertyAddress



SELECT *
FROM nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE nashvillehousing
DROP COLUMN SaleDate
