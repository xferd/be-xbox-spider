package xbox

import (
	"log"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/xferd/golib/array"
)

type ProductID string
type ProductIDList []ProductID

type LocalizedProperty struct {
	ProductTitle string
	ShortTitle string
	ProductDescription string
	ShortDescription string
	Images []struct {
		Height int
		Width int
		SortOrder string
		Uri string
	}
	EligibilityProperties *struct {
		Affirmations []struct {
			AffirmationProductId string
			Description string
		}
	}
	Markets []string
}

type Product struct {
	ProductId string
	LocalizedProperties []LocalizedProperty
	DisplaySkuAvailabilities []struct {
		Sku struct {
			Properties struct {
				IsTrial bool
			}
		}
		Availabilities []struct {
			Actions []string
			DisplayRank int64
			OrderManagementData struct {
				Price struct {
					CurrencyCode string
					ListPrice float64
					MSRP float64
					IsPIRequired bool
				}
			}
			Remediations []struct {
				BigId string
			}
			RemediationRequired bool
			Properties struct {
				MerchandisingTags []string
				OriginalReleaseDate string
			}
		}
	}
}

type Products struct {
	Products []Product
}

var (

)

func ProductsFromJSON(jsonString string) *Products {
	log.Printf("json length: %+v", len(jsonString))
	products := &Products{}
	if err := json.Unmarshal([]byte(jsonString), products); nil != err {
		panic(err)
	}
	return products
}

func (ps *Products)InsertDB() error {
	for _, p := range ps.Products {
		if err := p.InsertDB(); nil != err {
			return err
		}
	}
	return nil
}

func (p *Product)InsertDB() error {
	return InsertUpdateGame(p)
}

func (list ProductIDList)Join(sep string) string {
	a := []string{}
	for _, id := range list {
		a = append(a, string(id))
	}
	return strings.Join(a, sep)
}

func (list ProductIDList)ProductURL(market, languages string) string {
	return fmt.Sprintf("https://displaycatalog.mp.microsoft.com/v7.0/products?bigIds=%s&market=%s&languages=%s&MS-CV=DAU1mcuxoWMMp+F.1",
			list.Join(","), market, languages)
}

func (p *Product)Markets() {
	// json.Unmarshal
}

func (p *Product)GetPrice() (currencycode string, listprice, msrpprice float64) {
	// var onsale = false
	// var gwg = false
	// var golddiscount = false // deals with gold ... and gold member sale prices?
	var goldandsilversale = false
	// var goldandsilversalegoldprice = 100000000.0
	// var specialprice = 100000000.0
	// var eaaccessgame = false
	// var gamepassgame = false
	// var purchasable = false
	var tempea = false
	var tempgs = false
	var goldaffids = []string{};
	
	lp := p.LocalizedProperties[0]
	if lp.EligibilityProperties != nil {
		for _, aff := range lp.EligibilityProperties.Affirmations {
			desc := strings.ToLower(aff.Description)
			if strings.Contains(desc, "ea access") {
				tempea = true
			}
			if strings.Contains(desc, "game pass") {
				// gamepassgame = true
			}
			if strings.Contains(desc, "gold") {
				tempgs = true
				goldaffids = append(goldaffids, aff.AffirmationProductId)
			}
		}
	}

	for _, sku := range p.DisplaySkuAvailabilities {
		var purchnum = 0
		for ind, av := range sku.Availabilities {
			if array.StringContains(av.Actions, "Purchase") {
				// purchasable = true
				purchnum++
				if purchnum > 1 && tempgs && av.RemediationRequired && array.StringContains(goldaffids, av.Remediations[0].BigId) {
					goldandsilversale = true
				}
			}

			omd := av.OrderManagementData
			price := omd.Price
			if array.StringContains(av.Actions, "Purchase") && (price.MSRP != 0 || (price.MSRP == 0 && price.ListPrice == 0)) &&
			!sku.Sku.Properties.IsTrial {
				if (price.ListPrice != price.MSRP || price.MSRP == 0) || (price.ListPrice == 0 && price.MSRP == 0) && ind != 0 {
					// specialprice = price.ListPrice
				} else {
					listprice = price.ListPrice
				}
				if ind == 0 {
					msrpprice = price.MSRP
				}
				currencycode = price.CurrencyCode
				if len(av.Properties.MerchandisingTags) > 0 {
					if array.StringContains(av.Properties.MerchandisingTags, "LegacyGamesWithGold") {
						// gwg = true
						// specialprice = listprice
						listprice = msrpprice
					}
					if array.StringContains(av.Properties.MerchandisingTags, "LegacyDiscountGold") {
						// golddiscount = true
					}
				}
				if goldandsilversale && av.DisplayRank == 1 {
					// goldandsilversalegoldprice = price.ListPrice
				}
				if tempea && len(av.Actions) == 2 {
					// eaaccessgame = true
				}
				// if listprice < msrpprice {
				// 	onsale = true
				// }
			}
		}
	}
	return
}

func (p *Product)GetPrice1(market string) (currencycode string, listprice, msrpprice float64) {
	// var onsale = false
	// var gwg = false
	// var golddiscount = false // deals with gold ... and gold member sale prices?
	var goldandsilversale = false
	// var goldandsilversalegoldprice = 100000000.0
	// var specialprice = 100000000.0
	// var eaaccessgame = false
	// var gamepassgame = false
	// var purchasable = false
	var tempea = false
	
	for _, sku := range p.DisplaySkuAvailabilities {
		for ind, av := range sku.Availabilities {

			omd := av.OrderManagementData
			price := omd.Price
			if array.StringContains(av.Actions, "Purchase") && (price.MSRP != 0 || (price.MSRP == 0 && price.ListPrice == 0)) &&
			!sku.Sku.Properties.IsTrial {
				if (price.ListPrice != price.MSRP || price.MSRP == 0) || (price.ListPrice == 0 && price.MSRP == 0) && ind != 0 {
					// specialprice = price.ListPrice
				} else {
					listprice = price.ListPrice
				}
				if ind == 0 {
					msrpprice = price.MSRP
				}
				currencycode = price.CurrencyCode
				if len(av.Properties.MerchandisingTags) > 0 {
					if array.StringContains(av.Properties.MerchandisingTags, "LegacyGamesWithGold") {
						// gwg = true
						// specialprice = listprice
						listprice = msrpprice
					}
					if array.StringContains(av.Properties.MerchandisingTags, "LegacyDiscountGold") {
						// golddiscount = true
					}
				}
				if goldandsilversale && av.DisplayRank == 1 {
					// goldandsilversalegoldprice = price.ListPrice
				}
				if tempea && len(av.Actions) == 2 {
					// eaaccessgame = true
				}
				// if listprice < msrpprice {
				// 	onsale = true
				// }
			}
		}
	}
	return
}

func (id ProductID)DetailPageURL(lang Lang) string {
	return ""
}