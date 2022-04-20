# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_item(category:, title:, description:, price_usd:, google_image_id:, image_name: nil, weight_gross_gr: 250, storage_amount: 5)
  item = category.items.create!(
      title: title, 
      description: description, 
      price: Money.from_cents(price_usd, "USD"), 
      weight_gross_gr: weight_gross_gr,
      google_image_id: google_image_id
    )
  item.stock.update(storage_amount: storage_amount)
end

ConversionRate.create!(from: "RUB", to: "BTC", rate: 0.000000304000322)
ConversionRate.create!(from: "BTC", to: "RUB", rate: 3_289_470.20)
ConversionRate.create!(from: "RUB", to: "USD", rate: 0.012110119)
ConversionRate.create!(from: "USD", to: "RUB", rate: 82.483862)
ConversionRate.create!(from: "USD", to: "BTC", rate: 0.0000251001)
ConversionRate.create!(from: "BTC", to: "USD", rate: 39_841.272)

admin     = User.create!(email: "admin@example.com", password: "xxxxxx", type: "Admin")
customer  = User.create!(email: "customer@example.com", password: "xxxxxx", type: "Customer")

backpacks = Category.create!(title: "Backpacks")
bracelets = Category.create!(title: "Bracelets")
fossils = Category.create!(title: "Fossils")
mugs = Category.create!(title: "Mugs")

create_item(
    category: backpacks, 
    title: "Battleship Grey Retro Backpack", 
    description: "Vintage Canvas & Leather Backpack | All purpose backpack for men | Waterproof Oil Wax | Travel Backpack Large | Retro Backpack. | Battleship Grey

FEATURES

Roll top design with magnetic closure points
Cross attachment compression straps
Moisture resistant waxed cotton fabrication
Cowhide leather trim and detailing
Quick access front panel zip pockets
Internal sleeve fits most 15” laptops
Padded shoulder straps and back panel
Zip close pocket to rear back panel
Interior pockets and pouches


FABRICATION

High density waxed cotton canvas outer
Wax treated cowhide leather straps and details
Adjustable and padded canvas shoulder straps
Rust resistant alloy rivets and hardware
Soft padded cotton canvas back panel
Soft touch polyester cotton on the interior of the pack


DETAILS

Colour: Battleship Grey
Capacity: 18 litres
Dimensions: 48 x 38 x 10 cm
Weight: 1.3kg", 
    price_usd: 121_02, 
    # image_name: "il_794xN.3341280794_agcf.webp"
    google_image_id: "1mS_2wPlek997O4mrJbRV0YAS3FgKsGAG",
  )

# https://www.etsy.com/listing/1090241699/mens-and-womens-backpack-oxford-backpack?click_key=9d96cb880cb10b763aeffd324eb9043938f34d92%3A1090241699&click_sum=48399a98&ref=search_recently_viewed-4&pro=1&frs=1
create_item(
    category: backpacks, 
    title: "Vintage Travel backpack", 
    description: "Detailed:
Handmade Bag
[Product name]: Backpacks
[Material]: Oxford cloth
[Color]: Black
[Size]:Length 31cm, Height 48, Wdth 14cm

*Can put 14-inch notebooks, A4 textbooks, etc.

Description:
Men's and women's backpack, Oxford backpack, Reusable school backpack, Vintage backpack, Travel backpack, High-capacity backpack

*Choose one of the printing seats, send me a picture, or leave a message. After personalizing the payment, pay attention to check our email, we will communicate with you the specific content and location of the personalized, font size and other issues as soon as possible.Currently there are only classic uppercase fonts, black and white.
Three letter sizes: S1-Letter height 29mm, S2-Letter height 17mm, S3-Letter height 13mm, S4-Letter height 9mm

Simple, multifunctional, high-capacity backpack with 3 colors. It can store mobile phones, wallets, cameras, water bottles, sunglasses, cosmetics, folding umbrellas, folding hats, books,
computers and other items. Widely used: very suitable for school, work, shopping, tourism or daily leisure.
Before delivery, the quality will be strictly checked, and then carefully packed before delivery. You can buy our bags at ease.

*Can put 14-inch notebooks, A4 textbooks, etc.

PS: the lighting effect of the studio is different from that of the natural light. There may be a little color difference between the picture and the real object, which is not a quality problem.", 
    price_usd: 40_32, 
    # image_name: "il_794xN.3350223336_mgn0.webp"
    google_image_id: "1O7eaAfhaVBuqAX5p-MMTe9wFLMxAQgvf"
  )

# https://www.etsy.com/listing/1118418581/ultimate-diaper-bag-backpack-with?click_key=c6627f9cf5be9e3a867333c1f53253954dda8b31%3A1118418581&click_sum=a12ec451&ref=search_recently_viewed-2&pro=1
create_item(
    category: backpacks, 
    title: "Baby Care Bag Travel Backpack", 
    description: "Large Capacity Diaper Bag Backpack: This spacious diaper bag backpack will easily fit everything your baby needs and make traveling with your little one more convenient on all occasions.", 
    price_usd: 29_99, 
    # image_name: "il_794xN.3767053267_kff2.webp"
    google_image_id: "1jrr15lazjjiBV4tUgRhFC192RGyxcE1Z"
  )

# https://www.etsy.com/listing/836525397/oxford-backpack-in-real-leather?click_key=c20585aea30b842b2115e0394478720baf058d9a%3A836525397&click_sum=016074cd&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=backpack&ref=sr_gallery-2-39&organic_search_click=1
create_item(
    category: backpacks,
    title: "Oxford backpack in real leather", 
    description: "Vera Pelle Tamponata tanned with Vegetable

100% Made in Italy

Handle

equipped with double outer compartment with clip

PC port and pen-holder

zipped pockets

External closure with clip

Size in cm: 32 x 36 x 18


⚠Every layer of real skin, some more others less, always has some defect as it is normal to be. For example you can see different growth lines, small wrinkles, black spots etc.

⚠Sisicco is real skin, there are no two identical layers, every texture, shine and color will be slightly different and for this reason each finished product will be unique.

⚠During use, the product will slowly develop its unique brillium and consistency. Therefore it will become a real skin product with your own and exclusive characteristics.", 
    price_usd: 305_73, 
    # image_name: "il_794xN.2451632059_px4l.jpg"
    google_image_id: "16k4RwObeW1EVR_CrdG3r7DWCAyjRQX50"
  )

# https://www.etsy.com/listing/623202585/diaper-bag-backpack-brown-leather?click_key=de8215c06a3490f4858493378a446d7e347e7b4e%3A623202585&click_sum=7ee9cb53&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=backpack&ref=sr_gallery-3-47&organic_search_click=1&pro=1
create_item(
    category: backpacks, 
    title: "Diaper Bag Backpack", 
    description: "👜 Women Leather Backpack 👜 Minimalist and Classic Leather Backpack For Women, Handmade by MAYKO, Available in a few colors, can be Personalized!👜

This Classic MAYKO leather backpack is handcrafted and made of 100% genuine Leather. We offer the bag in two types of leather, the Basic collection is made out of lightweight leather, and the Premium collection is made from better quality and thicker leather. This bag designs with one big compartment and another large open pocket inside it, and it all close with a zipper closure that comes under the flap, adjustable straps to fit perfectly on your shoulder. This minimalist bag is pragmatic, timeless, and will last a lifetime.

The bag has enough space for carrying a laptop (up to 15 inches), documents, or a notebook, and the small pocket will be perfect for mobiles, cosmetics, keys, etc. In addition, we recommend adding the Outside back pocket for easy access to your mobile, wallet, and keys while the bag is closed. These simple, clean design backpacks are available in various colors, and they will complete your stylishly casual look.

Our leather backpack will be a great everyday bag for school, work, travel, and more uses... It will also make a wonderful gift for someone you love 💖", 
    price_usd: 99_50, 
    google_image_id: "1rWE8scHP28tx5O1xEZRldeqIsQlpBoX0",
    storage_amount: 0
  )

# https://www.etsy.com/listing/1030959180/embroidered-red-dragon-backpack?click_key=4e526278e80267d71a7cebe1255cce2003d73737%3A1030959180&click_sum=c9da850a&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=backpack&ref=sr_gallery-4-35&organic_search_click=1
create_item(
    category: backpacks, 
    title: "Embroidered red dragon Backpack", 
    description: "Featuring a stunning design along a padded back and adjustable shoulder straps, this embroidered backpack combines functionality and good looks. Use the two-way zipped main compartment to carry anything from a 15-inch laptop to books, and keep your phone and keys safe in the front zip pocket.

• 100% polyester, 600D
• Two-tone fabric
• Dimensions: H 16.5″ (42 cm), W 12.2″ (31 cm), D 8.3″ (21 cm)
• Capacity: 4.7 gallons (18 l)
• Top carry handle
• Front zip pocket
• Top zipper with 2 sliders and zipper pullers
• Large main compartment with padded back panel
• Padded adjustable shoulder straps in matching fabric
• Blank product sourced from China", 
    price_usd: 47_59, 
    # image_name: "il_794xN.3227332687_mbry.webp"
    google_image_id: "1BmES3oMzfsJL_xx-q6gfu4JCQ6np1wf4"
  )

# https://www.etsy.com/listing/803876617/mary-poppins-london-backpack?click_key=c0e33fa037a540dd97e9e35a294625a0b9a08b80%3A803876617&click_sum=04b2a3bc&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=backpack&ref=sr_gallery-5-20&organic_search_click=1&frs=1
create_item(
    category: backpacks, 
    title: "Mary Poppins London Backpack", 
    description: "This medium size backpack is just what you need for daily use or sports activities! The pockets (including one for your laptop) give plenty of room for all your necessities, while the water-resistant material will protect them from the weather.

• Made from 100% polyester
• Dimensions: H 16⅞ (42cm), W 12¼ (31cm), D 3⅞ (10cm)
• Maximum weight limit – 44lbs (20kg)
• Water-resistant material
• Large inside pocket with a separate pocket for a 15” laptop, front pocket with a zipper, and a hidden pocket with zipper on the back of the bag
• Top zipper has 2 sliders, and there are zipper pullers attached to each slider
• Silky lining, piped inside hems, and a soft mesh back
• Padded ergonomic bag straps from polyester with plastic strap regulators
• Blank product components sourced from China", 
    price_usd: 54_39, 
    # image_name: "il_794xN.2340907389_ncjq.webp"
    google_image_id: "1sWyz45i6Xz5oYr87Ubq5pIuCSvxwr0NQ"
  )

create_item(
    category: backpacks, 
    title: "Handmade leather backpack personalized", 
    description: "Beautiful, handmade backpack made of vegetable inherited cowhide with personalization possible. The backpack has a large main compartment with front flap with two magnetic snap fasteners and a small zipper compartment inside. At the front there is another compartment with snap fasteners and on the back a zipper compartment. The straps are adjustable. Great eye-catcher for school, university, work, leisure or hiking. Suitable for a laptop, Din A4 documents and a water bottle. Each of our products is a real unique piece, because no two leathers are the same. With attention to detail, every product is handmade.

• Genuine leather
• Materials: cowhide
• Individually handmade
• Wearer Style: Shoulder
• Shipped by a small business in Germany
• Shipping in Germany up to one week, in Europe up to two weeks. International orders may take a little longer

Dimensions: 40x27x10

About SecLeder

Pure Natural

Our leather is a vegetable-inherited, chrome-free leather from Turkey. The leather is inherited with the help of oak bark, chestnuts, mimosas, quebracho. It is ecological and biodegradable. We use a self-made leather protector made from coconut oil, black cumin oil and olive oil.

Sustainable & Fair

Our products are designed in Germany and handmade in Turkey with a small company run in the 3rd generation. The small business works with students who need financial support for their studies. As a result, short production routes, fair payment and the elimination of intermediaries are possible. Since we attach great importance to sustainability, we only use leather, which is a by-product of meat production and remains as waste. This makes the leather an absolute recycling product. Our products are packaged in a recyclable way.", 
    price_usd: 124_91, 
    # image_name: "il_794xN.3663362346_orrf.webp"
    google_image_id: "1tIo_hsGYlhtHmzctiv5JwIZuqwbL5kI9"
  )

create_item(
    category: mugs, 
    title: "Campfire mug with fruit", 
    description: "Sale Vintage white enamel mug with picture fruit . Made in the USSR in the 1980s

Would be great for camping or country kitchen decorating. You can use it for storing items or even as a small flower pot.

Lovely decoration for your vintage themed home!

Mug is height 8 cm - 3.1 inches
Diameter 8,5 cm - 3.3 inches.

In great vintage condition.
In some mugs, the color of the paint may differ in intensity

ATTENTION!!! The price is for one mug. Please select the quantity you want when buying

If you have questions, please feel free to contact me prior the purchase!", 
    price_usd: 23_00, 
    google_image_id: "1t3wsZX-GK1qGjjJQxyJrGS4tfB-issLZ"
  )

create_item(
    category: mugs, 
    title: "Vintage set of 2 White Enamel Mug Rose", 
    description: "Vintage white enamel mug. Made in the USSR in the 1980s.

Would be great for camping or country kitchen decorating. You can use it for storing items or even as a small flower pot.

The mug has a fruit print

Lovely decoration for your vintage themed home!

Mug is 2.9 inches (7,5 cm) tall and 3.3 inches (8,5 cm) in diameter.

In great vintage condition. Mug is new, not used before. In some places there are factory defects. See photos

If you have questions, please feel free to contact me prior the purchase!", 
    price_usd: 49_00, 
    # image_name: "il_794xN.2689941701_6c2r.webp"
    google_image_id: "1Wk91E0CDRCBpyn92CUMpaoWkVjdBG8vo"
  )

# https://www.etsy.com/listing/510017282/vintage-yellow-enamel-mug-old-metal-cup?click_key=618b05f9101f5f21ff7179e91c3214a25b4324fa%3A510017282&click_sum=2bb6c801&ref=shop_home_recs_20&frs=1
create_item(
    category: mugs, 
    title: "Mug with Assorted Fruit", 
    description: "Vintage yellow enamel mug with fruit. Made in the USSR in the 1980s.

Perfect for camping or decorating a country kitchen. You can use it for storage or even as a small flower pot.

A perfect decoration for your vintage themed home!

The mug is 4.72'' (12cm) high and 4.33'' (11cm) in diameter.

Made in the USSR around the 80s.

Good vintage condition. There are signs of age. View photos

If you have any questions, please contact me before purchasing!", 
    price_usd: 38_50, 
    # image_name: "il_794xN.2738223460_nhet.webp"
    google_image_id: "1vq2jgEbGQ7oHl5qkyf8NCxhkUnTzHh9o"
  )

# https://www.etsy.com/listing/1015011354/enamel-mug-vintage-soviet-enamel-mug?click_key=2c44902d1b2a7b8c3791e779ab1ecd35b0f0aae5%3A1015011354&click_sum=6b9c917d&ga_order=most_relevant&ga_search_type=vintage&ga_view_type=gallery&ga_search_query=mug&ref=sr_gallery-1-44&organic_search_click=1&pro=1
# create_item(
#     category: mugs, 
#     # title: "Retro Mug - Flowers and leaves", 
#     title: "ry",
#     description: "ky",
#     # description: "For sale is a small enamel mug is great for camping, home use, cooking with, and everyone loves them. But unlike many plain ones, this vintage Soviet cup has a cool retro picture on it.
# # Wildflowers and leaves.", 
#     price_usd: 18_55, 
#     # image_name: "il_794xN.3119003252_3ur7.webp"
#   )

create_item(
    category: mugs, 
    title: "My mug", 
    description: "For sale is a small enamel mug is great for camping, home use, cooking with, and everyone loves them. But unlike many plain ones, this vintage Soviet cup has a cool retro picture on it. Wildflowers and leaves", 
    price_usd: 10_00, 
    # image_name: "il_794xN.3119003252_3ur7.webp"
    google_image_id: "1NcHYox9QR_pl_OYFKvMSXwIyMYGgK22J"
  )

create_item(
    category: bracelets,
    title: "Cuff Leather Zinc Hand Bracelets", 
    description: "Economical jewelry bracelet for men and women. 
    HIGH QUALITY MATERIAL: High quality hemp cords, bracelet made of braided leather and wooden beads, soft and comfortable to wear. 
    CLASSIC DESIGN: Simple and classic design for personal use, such as Father's Day, Vintage, Punk, Religion, Rock Band, Party, Travel, Daily Casual Clothes, etc. Economical jewelry bracelet for men and women.
    HIGH QUALITY MATERIAL: High quality hemp cords, bracelet made of braided leather and wooden beads, soft and comfortable to wear.", 
    price_usd: 18_25, 
    # image_name: "il_794xN.3799177096_ezwo.webp"
    google_image_id: "1atYi-2GRezJKhhpsX5jdfsy5DWvAD5ob"
  )

# https://www.etsy.com/listing/1027009065/upper-arm-bracelet-gold-arm-cuff-skinny?click_key=f8e3fc430b7b9ed7b7d072da68cb6127cb7d7d39%3A1027009065&click_sum=9e6ac035&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=&ref=sr_gallery-5-23&frs=1
create_item(
    category: bracelets, 
    title: "Gold Arm Cuff", 
    description: "Gold fill upper arm band bangle
    • Materials:14 Karat Gold filled

    Measurements:
    • Wire thickness: 0.07 inch / 1.8 - 2 mm approx.
    • Diameter: 3.15 inch / 8 cm approx.
    • Easily adjustable
    • Packed nicely in a gift box.
    • Handmade in Tel-Aviv
    • FREE SHIPPING worldwide

    Delicate Gold filled spiral upper arm bracelet featuring with overlapping open ends. The bangle is gently handcrafted and hammered with 14K gold filled wire. I use only the highest quality of materials in my jewelry and in this particular bracelet I hammer the gold fill wire to get the best sparkle gold look out of it. The bracelet can easily be bent to fit your upper arm.", 
    price_usd: 149_00, 
    # image_name: "il_794xN.3111327750_dhbo.webp"
    google_image_id: "1sa26SxzmXu8Cq_hYd5XoD9f8B9wJjhS9"
  )

# https://www.etsy.com/listing/906424321/moonstone-arm-cuff-silver-brass-swirl?click_key=e8ecdfc6fd4252295c7c104429174ca0534f182b%3A906424321&click_sum=9ea18900&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=&ref=sr_gallery-5-32
create_item(
    category: bracelets, 
    title: "Gypsy Festival Boho Jewelry", 
    description: "Gorgeous Moonstone with high quality rainbow flash set into a unique swirl arm cuff. This piece was masterfully crafted by Indian artisans who are renowned for their brass metalworking. We collected this along our Journeys through India.

It is completely adjustable to fit any size arm. Made with high quality tarnish resistant brass with three layers of silver plating.

Absolutely awesome!



*Satisfaction Guarantee*
We're sure you'll love this! But if you are not satisfied with your purchase for any reason, then you may return it for a full refund.


*About our shop*
For years we've traveled the globe, first as English teachers and then as collectors of unique traditional jewelry and folk art. Our collection represents the cultural heritage of the many of-the-beaten-track places we visit.", 
    price_usd: 26_95, 
    # image_name: "il_794xN.2715905645_bg27.webp"
    google_image_id: "1C0fi2xGrg83RFiBOcF14UvnuIMYN8OdE"
  )

# https://www.etsy.com/listing/779236161/vegan-leather-bracelet-with-driftwood?click_key=38440f4121961c9fe2cfdcdd7459c92c809fc023%3A779236161&click_sum=5c7f29d9&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=&ref=sr_gallery-6-34&cns=1
create_item(
    category: bracelets, 
    title: "Vegan Leather Bracelet with Driftwood 'World' Charm", 
    description: "A beautiful bracelet made out of soft vegan leather. The amulet is made out of driftwood, that we collect on the beaches of Bali. The pendant with a beautiful ´World´ incraving is painted with waterproof white color on wood. You can choose between 4 different vegan leather strings. They are super soft and comfortable to wear.If you like you can adjust the size in the back, it will fit everyone. The connection-ring, as well as the backside of the Charm is made out of 925k sterling silver. The Bracelet is waterproof. It´s the perfect Accessoire for your next summer vacation, adventure, surf trip.
Our pieces are all 100% handmade with love to details in Bali.
Choose your favourite color and get a piece of Bali delivered to you.", 
    price_usd: 39_87, 
    # image_name: "il_794xN.2239509335_ksmu.webp"
    google_image_id: "1ewtVklSjgXpjb_tpbIATm3rsGcpapHrU"
  )

# https://www.etsy.com/listing/703599052/minimalist-layered-leaf-arm-cuff?click_key=6a87da8964d2475c86c971a80300a18bd7099742%3A703599052&click_sum=285175a9&ga_order=most_relevant&ga_search_type=all&ga_view_type=gallery&ga_search_query=&ref=sr_gallery-6-11
create_item(
    category: bracelets, 
    title: "Minimalist Layered Leaf Arm Cuff", 
    description: "Minimalist Layered Leaf Arm Cuff - Chic Gold Silver Tone Metal Cuff Bracelet - Hammered Layered Upper Arm Band

This 14k gold silver tone Layered Leaf Charm Arm Cuff is truly a gift for her to wear for a warm heart and joyful days. It is so sweet and graceful by itself but can be worn with other accessories

Suitable for all kinds of occasions", 
    price_usd: 10_00, 
    google_image_id: "1gxxSNZh480Tdph_4imjGw7LabP64PaNl"
  )

# https://www.etsy.com/listing/664587304/authentic-fossil-mosasaur-halisaurus?click_key=31b5a5b59f6412383a5acd529037d612945963a1%3A664587304&click_sum=28f69a58&ga_order=price_desc&ga_search_type=all&ga_view_type=gallery&ga_search_query=dinosaur+fossil&ref=sr_gallery-1-1&organic_search_click=1&frs=1&cns=1
create_item(
    category: fossils, 
    title: "Authentic Fossil Mosasaur Halisaurus Arambourgi Skeleton on stand", 
    description: "From: Sidi Daoui, Morocco
Size: 78'' x 42'' x 22'' (as mounted). Skeleton is 81'' long from tail to chin.

Mosasaurs were ancient Marine Reptiles that lived 75-65 million years ago during the Maastrichtian age of the Late Cretaceous period. They went extinct during the Cretaceous Tertiary Extinction Event - the asteroid impact that wiped out the dinosaurs and 75% of all species on the planet. Mosasaurs were considered the top marine predators during the Late Cretaceous, and are sometimes referred to as the T. Rex of the Sea. They ate virtually everything they could swallow, and their jaws were similar to those of a snake because they were not hinged and could disarticulate to swallow large prey.
This exquisite fossilized Mosasaur skeleton belongs to the species Halisaurus Arambourgi. Most Mosasaur species are large and can be up to 55' in length, so they require a museum in which to be displayed; but Haliasaurus is a relatively rare, smaller species of Mosasaur which makes them easy to display in a home, office, or gallery. This particular fossil is 6' 9'' long - big enough to impress, but small enough to be practical. Maury the Mosasaur, as he is named, is 70-65 million years old, and he was discovered in 2014 in the phosphate beds of Sidi Daoui in Morocco.", 
    price_usd: 50_000_00, 
    google_image_id: "1CvJ-C4tElmdzq3R8e65HRK-US6Bl0QqQ",
    weight_gross_gr: 12_500,
    storage_amount: 1
  )

# https://www.etsy.com/listing/241158741/superb-rare-ancient-madagascar-dinosaur?click_key=9e88d52b8a1166da40aac05a91fe58720d7af74f%3A241158741&click_sum=57d438a9&ga_order=price_desc&ga_search_type=all&ga_view_type=gallery&ga_search_query=dinosaur+fossil&ref=sr_gallery-1-3&organic_search_click=1
create_item(
    category: fossils, 
    title: "Madagascar Dinosaur Egg", 
    description: "Superb rare ancient Madagascar Dinosaur Egg fossil gemstone w. 'hatched vascellum' . 12x10x4.5cm, 795 grams.perfect condition. multi-millions years old.", 
    price_usd: 18_000_00, 
    # image_name: "il_794xN.1512691455_hyng.webp",
    google_image_id: "1imJdhZVIhKj8FLTD6tpT99jAvmmwHFew",
    weight_gross_gr: 795,
    storage_amount: 0
  )

# https://www.etsy.com/listing/1147524236/amazing-megalodon-shark-tooth-fossil-o?click_key=1839a1d871f331b01c3cddf22f972cb660f0c48f%3A1147524236&click_sum=07293dbd&ga_order=price_desc&ga_search_type=all&ga_view_type=gallery&ga_search_query=dinosaur+fossil&ref=sr_gallery-3-12&organic_search_click=1
create_item(
    category: fossils, 
    title: "Megalodon Shark Tooth Fossil", 
    description: "A truly wonderful Megalodon Shark Tooth Fossil.

Amazing razor-sharp serrations, paired with a beautiful colour, enamel and root.

An exceptional specimen which would grace any World Class Fossil collection or interior design space. They simply do not get better than this.

From Java, Indonesia.
Miocene in age - 5 Million Years old.

Provided with a stand for ease of display, alongside a specimen label.",
    price_usd: 1_699_76, 
    # image_name: "il_794xN.3648811497_so7j.webp",
    google_image_id: "19dTTsmVYq3Yct6Pu36rdX626dMRalbz5",
    weight_gross_gr: 266
  )

# https://drive.google.com/thumbnail?id=19dTTsmVYq3Yct6Pu36rdX626dMRalbz5&sz=w250-h250

# https://www.etsy.com/listing/750534884/773-grams-45x-13x-08-rare-natural?click_key=68703918daa5df880b18c0f31eb307f99fbab7a4%3A750534884&click_sum=c8a5ad8f&ga_order=price_desc&ga_search_type=all&ga_view_type=gallery&ga_search_query=dinosaur+fossil&ref=sr_gallery-8-5&organic_search_click=1
create_item(
    category: fossils, 
    title: "Spinosaurus Tooth", 
    description: "77.3 Grams, 4.5''x 1.3''x 0.8'' Rare Natural Fossils Spinosaurus Tooth, Dinosaur Tooth, Mineral, Specimen, Theropod, EeF3264
Age: About 90-112 Millions Years Old or so.
Origin: Morocco", 
    price_usd: 599_99, 
    google_image_id: "1sQGHpNrzsi01ym95wX-6bMbW15FdIbVm",
    weight_gross_gr: 73
  )

# create_item(
#     category: fossils, 
#     title:, 
#     description:, 
#     price_usd:, 
#     image_name:
#   )