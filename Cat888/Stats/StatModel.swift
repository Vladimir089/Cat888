//
//  StatModel.swift
//  Cat888
//
//  Created by Владимир Кацап on 05.09.2024.
//

import Foundation
import UIKit

struct Stat {
    let header: String
    let image: UIImage
    let text: String
    
    init(header: String, image: UIImage, text: String) {
        self.header = header
        self.image = image
        self.text = text
    }
}

extension StatMenuViewController {
    
    func fillStatArr() {
        let catStat = Stat(header: "Castration of cats and sterilization of cats", image: .cats, text: """
                    The only reason an owner might refuse to neuter their cat is if the pet has significant breeding value. Otherwise, a cat should be neutered at around six months of age. At this age, the testicles descend, allowing the veterinarian to remove them.
                    
                    Neutering a cat has a very positive effect on its temperament, as it results in an almost ideal house pet. The natural aggression in cats, driven by their instinct to defend their territory, significantly diminishes, reducing the risk of serious injuries from fights with other cats. This also somewhat protects your pet from dangerous feline diseases such as leukemia or feline immunodeficiency syndrome. However, if the cat had the habit of marking its territory with urine before the operation, it is likely to continue doing so after being neutered.
                    
                    When spaying female cats, the veterinarian completely removes both the uterus and the ovaries; otherwise, the cat will continue to go into heat. As with male cats, this surgery is most appropriate at around six months of age. Spaying can help prevent uterine infections in your pet. The surgical risk associated with spaying a female cat is significantly higher than that of neutering a male cat because the procedure involves operating within the abdominal cavity. However, cat owners should not worry too much, as the pet can usually be taken home the morning after surgery.
                    
                    During the operation, the veterinary surgeon may make an incision on the side of the animal. This type of surgical approach has its advantages. However, if the cat is a titled show winner, it is better to make the incision along the midline of the belly. This option does not significantly alter the pet's appearance and will not affect its future prospects in shows. At the end of the surgery, the wound will be sutured, and the stitches will be removed by the veterinarian only after two weeks. During this period, the owner should carefully monitor their pet to prevent it from removing the stitches prematurely. Naturally, neutering or spaying cannot be performed without general anesthesia. It is worth noting that such anesthesia carries some risk for cats. However, the potential danger is minimal and mostly applies to elderly animals with heart or lung problems. The anesthesia procedure itself is very simple. At the right moment, the veterinarian injects a sedative, usually in the foreleg, putting the cat to sleep. Throughout the operation, the anesthesia is maintained with gas administered through a mask. For this reason, the cat should not be fed the evening before surgery, as food remaining in the stomach could trigger a vomiting reflex under anesthesia, which could be fatal for the animal.
                    """)
        
        let dogStat = Stat(header: "We decided to get a puppy. What to prepare for?", image: .dog, text: """
                        **Do I need to prepare the house for a puppy?**
                    You're absolutely right. First, decide which room the puppy will spend most of its time in and remove anything valuable from it. Otherwise, your favorite slippers and bean bag chair will be shredded to pieces since the puppy needs to chew on things to sharpen its teeth, and anything chewable will do.
                    
                    If you can't hide the wires or move your favorite couch, at least spray them with a special spray that makes things unattractive to the puppy.
                    
                    **I understand the spray part, but what about feeding the puppy?**
                    Get food and water bowls. It’s best to use metal or ceramic ones since they’re easier to clean. For metal bowls, it’s important to carefully choose the material: the bowl must be made of stainless steel to prevent the pet from being poisoned by oxidized or damaged materials. Also, keep in mind that as the dog grows, you will need bigger bowls, so you might want to buy larger ones from the start.
                    
                    Find out what the puppy was eating with its previous owners and buy the same food. After a week, you can gradually start transitioning to a new diet. The important thing is that the diet is balanced and suitable for the puppy. Don't forget about treats as rewards — they will definitely come in handy. Well-known brands also produce treats, just make sure to check the recommended age for giving them.
                    
                    **What else should I buy?**
                    **Toys.** Make sure to get ones that can replace your slippers. Let the puppy chew on accessories designed for that purpose. Choose toys of various shapes and textures to see which ones the new family member prefers.
                    
                    **Leash and muzzle.** However, the latter isn’t needed for puppies under three months or for dogs whose height does not exceed 25 centimeters at the withers. Also, don't forget an ID tag. Put the pet's name and your contact phone number on it.
                    
                    **Dog bed.** Choose one that will fit as the puppy grows. After all, a small Labrador will soon become an adult and need much more space.
                    
                    **Nail clippers.** Dogs' claws "stick out," and while puppies are walking around the apartment, they may scratch the floors (potentially also the furniture and wallpaper). But that's not the worst part: in severe cases, long nails can lead to inflammation and deformation of the paw pads. To check if it's time to clip the nails, simply place the pet on a flat surface. If the nails touch the floor, it's time to trim them.
                    
                    **It seems everything is ready. Can we bring the puppy now?**
                    No. First, hold a family meeting. Explain to the children that the pet cannot be held constantly or always expected to be active. Both puppies and adult dogs need time to rest.
                    
                    Another important point is consistent commands. Agree on which words will be used for commands like "stop" and "allow." If one family member says "no," another says "stop," and a third says "leave it," the puppy will get confused and never learn the correct commands.
                    
                    This also applies to behavior. If you're willing to let the dog jump on the couch or bed, the whole family must agree. It's not fair for one person to forbid what another allows.
                    
                    Also, discuss with all family members where the dog's place will be. It will need its own corner.
                    
                    **A corner of its own? What does that mean?**
                    This is a place where the dog will sleep, have some privacy to chew on its favorite toy, or just spend some time alone. Ideally, this could be a large, specialized dog bed that you can buy at pet stores. From a young age, the puppy will learn to see this place as its fortress, where no one will bother it.
                    
                    Initially, you can place a bottle or hot water bottle in the bed. This is helpful for puppies taken away from their mom, brothers, and sisters. They're used to having something warm nearby to cuddle up to when they fall asleep.
                    
                    **We've discussed and done everything. Can we bring the puppy now?**
                    Now you can. You've already designated a room where the puppy will spend the initial adaptation period. Don't rush to let it explore the whole house or apartment. The more space it has, the more opportunities there are for mischief. Let it first get acquainted with one room.

                    The family can also greet the newcomer. If you have already chosen a name, start calling the puppy by it right away.
                    
                    It's best to bring the puppy home on a weekend or during a vacation so it won't be left alone for an entire day right away. This would be traumatic for a puppy. Gradually increase the time the puppy spends alone each day, so it gets used to it and won't react negatively when you leave for work or school.
                    
                    Every dog is different. Some will be ready to run and play after five minutes, while others may need more time to adjust.
                    
                    **People say puppies cry a lot during the first few nights. Is that true?**
                    In most cases, yes. They're in an unfamiliar environment. Their mother, brothers, and sisters are no longer around. Naturally, they're scared and miss them. Be prepared for at least the first night to be sleepless.
                    
                    For a while, the puppy can sleep in the same room as you. This will help it feel more secure. If the bed you've set up for it is comfortable, use it. Place it next to your bed and let the puppy sleep there. Don’t forget the warm bottle. If it starts crying, just reach out and gently pat it to calm it down. The next bout of whining can be ignored. When the puppy calms down on its own, give it a treat.
                    
                    And, of course, don't forget to take the puppy to the bathroom before bed.
                    
                    **Speaking of the bathroom, how do I train a puppy to use it?**
                    You need patience. A puppy under three months old will need to go to the bathroom at least every three hours — if not, there might be a health issue. Watch its behavior to learn to recognize when it needs to go outside. When you can't keep an eye on it, let it stay in its designated area. Dogs generally don't soil where they sleep, so the chance of an "accident" there is minimal.
                    
                    If you have the time, take the puppy outside every hour or two. As soon as it goes to the bathroom in the right place, praise it and give it a treat.
                    
                    And never hit or scold the puppy if it doesn't hold it in. It won't stop needing to go to the bathroom but will try to do it where you can't see. Better a puddle in the middle of the hallway than behind the couch.
                    
                    **When should we go to the vet?**
                    The sooner, the better. If you are purchasing an expensive breed, it's best to take the puppy to the vet before buying it. The specialist will assess the puppy’s overall health and check for genetic diseases.
                    
                    If the puppy is already bought, you should visit the vet within the first few days of bringing it home. The puppy should receive its first vaccine at 2 months old. The vet will then outline a vaccination schedule.
                    
                    The vet will also recommend an optimal diet, as food should be balanced and suitable for the dog's age, breed, and size.
                    
                    **What about training and education?**
                    You should start training the dog from its first minutes in the new home, teaching it what is allowed and what isn’t. Begin with simple commands: "no," "sit," "lie down," "place," "paw." Puppies actively absorb information until they are 14-16 weeks old. They will continue to learn afterward, but the skills developed early will stay with them forever. This is also the time to introduce them to as many people as possible and ensure they have positive experiences with children and other animals.
                    
                    And remember: dogs need routine. From day one, try to wake up and go to bed at the same time, and establish a schedule for meals, bathroom breaks, walks, and playtime. The sooner the dog gets used to a routine, the quicker it will adjust. The puppy will be ready to eat, sleep, and go to the bathroom at set times rather than whenever it feels like it.
                    """)
        
        let shinStat = Stat(header: "Chinchilla. Care and maintenance", image: .chin, text: """
                    **Who is it?**
                    
                    A chinchilla lives in the remote mountainous regions of South America. In appearance, it resembles a rabbit and a squirrel: it has long ears, a fluffy tail, and soft, dense fur.
                    
                    The fur of chinchillas not only keeps them warm during the cold season but also serves as a form of protection against predators: if necessary, these rodents can shed their fur to slip out of the claws of attacking animals.
                    
                    The weight of an adult chinchilla ranges from 0.5 to 1 kg. The body length is 19.6-38 cm. The tail (8-17 cm) is strong and flexible, acting as a balancer when these animals make sudden jumps or escape from predators.
                    
                    Chinchillas have very expressive faces, largely due to their large black eyes. The round, movable ears are located on top of the head and are relatively small—3-6 cm long. Chinchillas are known for their well-developed whiskers—vibrissae. These whiskers, reaching 8-10 cm in length, stick out in different directions, giving chinchillas a very charming appearance. Chinchillas have night vision but can see well during the day too.
                    
                    When feeling displeased or threatened, they make a sound that resembles a growl.
                    
                    In the wild, chinchillas live for about 10 years, but in captivity, they can live up to 20 years.
                    
                    **How to care for them?**
                    
                    Chinchillas can comfortably live in a typical city apartment. The space should be bright, dry, and well-ventilated. The animals are sensitive to drafts and direct sunlight, which can lead to various illnesses.
                    
                    A cage is the most universal and best type of housing for chinchillas. The minimum dimensions for a cage to house one chinchilla are 50x70x50 cm (width, length, and height). The cage should be prepared before settling a chinchilla: install wooden shelves for the chinchilla to run on, set up a water bottle (preferably automatic), a food bowl, and a hay rack (so the animal doesn’t trample it).
                    
                    The bottom of the cage should be covered with a mixture of dry, medium-sized alder or beech shavings and sawdust. This should be partially replaced daily and fully replaced weekly. For feeding chinchillas, it is recommended to use glass or clay dishes.
                    
                    Chinchillas need regular bathing in sand. Bathing containers can be made of metal, ceramic, or sturdy glass. Place the bathing container in the cage daily (preferably in the evening) and leave it for 1 to 1.5 hours.
                    
                    The stone for grinding teeth should not be too large. You can also provide wooden (preferably birch) or cardboard sticks for chinchillas to grind their teeth.
                    
                    Large wheels are placed both inside and outside the cage for chinchillas. The main requirement is a solid surface.
                    
                    **What to feed them?**
                    
                    For feeding chinchillas, you can use both meadow and common grasses. However, fresh greens should only be used as a supplement to the main diet, as they can cause gastrointestinal disturbances.
                    
                    Additional treats include all kinds of dried fruits and vegetables, muesli, and dried fruits that are natural and free from chemical treatments. Chinchillas love dried nettle, dandelions, willow twigs, and fruit tree branches, as well as linden blossoms, plantain leaves, and calendula flowers.
                    
                    **Training**
                    
                    Chinchillas can be trained to follow various commands: "come here," "walk," "home," "no," and others of your choice. Initially, reward the animal with a treat every time it follows your command. Later, reduce this to once every five times. Remember, what you perceive as training is just a game for the chinchilla!
                    
                    To the chinchilla, you are both a "heater" (it will warm its paws on you) and a "burrow" (it will hide in the folds of your loose clothing), and also a "chinchilla" (if you lay your hand palm-up, the animal will come to walk on your hand, sniff, and touch it).
                    
                    Chinchillas are very punctual. They have very precise internal clocks and begin to worry if you do not feed them or delay their bath even by an hour.
                    
                    Additionally, most chinchillas are confined in a cage for 22 hours a day and need something to do. One way to keep a chinchilla happy and, consequently, healthy, is to provide various objects that it likes in its cage.
                    
                    A chinchilla is not just a pet that brings you joy; it is a living being that requires care and attention. Do not forget this, and the rodent will bring you much happiness.
                    """)
        
        arr = [catStat, dogStat, shinStat]
    }
    
}
