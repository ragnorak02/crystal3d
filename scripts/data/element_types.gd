class_name ElementTypes
## Element definitions for future magic system.
## Elements follow a rock-paper-scissors weakness cycle:
##   Fire > Ice > Wind > Earth > Fire

enum Element {
	NONE,
	FIRE,
	ICE,
	WIND,
	EARTH,
}


## Returns the element that the given element is strong against.
static func get_strength(element: Element) -> Element:
	match element:
		Element.FIRE: return Element.ICE
		Element.ICE: return Element.WIND
		Element.WIND: return Element.EARTH
		Element.EARTH: return Element.FIRE
		_: return Element.NONE


## Returns the element that the given element is weak against.
static func get_weakness(element: Element) -> Element:
	match element:
		Element.FIRE: return Element.EARTH
		Element.ICE: return Element.FIRE
		Element.WIND: return Element.ICE
		Element.EARTH: return Element.WIND
		_: return Element.NONE
