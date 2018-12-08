package xbox

import (
	"encoding/json"
	"fmt"
	"strings"
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
	Markets []string
}

type Product struct {
	ProductId string
	LocalizedProperties []LocalizedProperty
}

type Products struct {
	Products []Product
}

var (

)

func ProductsFromJSON(jsonString string) []Product {
	products := &Products{}
	if err := json.Unmarshal([]byte(jsonString), products); nil != err {
		panic(err)
	}
	return products.Products
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
