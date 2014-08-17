/obj/item/weapon/storage/fluff/surgicalbag
	name = "Surgical Bag"
	desc = "A bag which can hold all the tools a surgeon would need."
	icon = 'icons/obj/storage.dmi'
	icon_state = "surgicalbag"
	w_class = 3.0
	storage_slots = 14
	max_combined_w_class = 25
	max_w_class = 3
	can_hold = list(
		"/obj/item/weapon/circular_saw",
		"/obj/item/weapon/scalpel",
		"/obj/item/weapon/bonesetter",
		"/obj/item/weapon/surgicaldrill",
		"/obj/item/weapon/cautery",
		"/obj/item/weapon/hemostat",
		"/obj/item/weapon/retractor",
		"/obj/item/weapon/bonegel",
		"/obj/item/weapon/FixOVein",
		"/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey",
		"/obj/item/weapon/soap",
		"/obj/item/stack/medical/ointment",
		"/obj/item/clothing/gloves/latex",
		"/obj/item/clothing/mask/surgical"

	)

	New()
		..()
		new /obj/item/weapon/circular_saw(src)
		new /obj/item/weapon/scalpel(src)
		new /obj/item/weapon/bonesetter(src)
		new /obj/item/weapon/surgicaldrill(src)
		new /obj/item/weapon/cautery(src)
		new /obj/item/weapon/hemostat(src)
		new /obj/item/weapon/retractor(src)
		new /obj/item/weapon/bonegel(src)
		new /obj/item/weapon/FixOVein(src)
		new /obj/item/weapon/soap(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/clothing/mask/surgical(src)