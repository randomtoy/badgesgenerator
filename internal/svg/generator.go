package svg

import "fmt"

func GenerateBadgeSVG(url string, count int64) string {

	const template = `
	<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="103" height="20">
		<linearGradient id="smooth" x2="0" y2="100%%">
			<stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
			<stop offset="1" stop-opacity=".1"/>
		</linearGradient>

		<mask id="round">
			<rect width="103" height="20" rx="3" ry="3" fill="#fff"/>
		</mask>

		<g mask="url(#round)">
			<rect width="51" height="20" fill="#555555"/>
			<rect x="51" width="52" height="20" fill="#79C83D"/>
			<rect width="103" height="20" fill="url(#smooth)"/>
		</g>

		<g fill="#fff" text-anchor="middle" font-family="Verdana,DejaVu Sans,Geneva,sans-serif" font-size="11"> 
			<text x="26.5" y="15" fill="#010101" fill-opacity=".3">visitors</text>
			<text x="26.5" y="14" fill="#fff">visitors</text>
			<text x="76" y="15" fill="#010101" fill-opacity=".3">%d</text>
			<text x="76" y="14" fill="#fff">%d</text>
		</g>
	</svg>
`
	return fmt.Sprintf(template, count, count)
}
