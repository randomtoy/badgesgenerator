package svg

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGenerator_GenerateBadgeSVF(t *testing.T) {
	count := int64(10)
	expectedSubstr := `<text x="76" y="14" fill="#fff">10</text>`
	svg := GenerateBadgeSVG(count)
	t.Run("SVG is valid", func(t *testing.T) {
		assert.NotEmpty(t, svg)
		assert.Contains(t, svg, expectedSubstr)
		assert.Contains(t, svg, "<svg xmlns")
	})

}
