#include <stdio.h>
#include "animal.h"
#include "my_string.h"

// Global array of Animal structs
struct animal animals[MAX_ANIMAL_LENGTH];

int size = 0;

// Custom method
int isItSame(struct animal animal1, struct animal animal2) {
  if (animal1.id == animal2.id) {
    return 1; // It is same
  }
  return 0;
}

/** addAnimal
 *
 * @brief creates a new Animal and adds it to the array of Animal structs, "animals"
 *
 *
 * @param "species" species of the animal being created and added
 *               NOTE: if the length of the species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH. If the length
 *               is 0, return FAILURE.  
 *               
 * @param "id" id of the animal being created and added
 * @param "hungerScale" hunger scale of the animal being created and added
 * @param "habitat" habitat of the animal being created and added
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "species" length is 0
 *         (2) "habitat" length is 0
 *         (3) adding the new animal would cause the size of the array "animals" to
 *             exceed MAX_ANIMAL_LENGTH
 *        
 */
int addAnimal(const char *species, int id, double hungerScale, const char *habitat)
{
  // int animalSize = sizeof(animals) / sizeof(animals[0]);
  if (my_strlen(species) == 0 || my_strlen(habitat) == 0 || size >= MAX_ANIMAL_LENGTH) {
    return FAILURE;
  }
  struct animal plusAnimal;
  
  size_t speciesLen  = my_strlen(species);
  if (speciesLen > MAX_SPECIES_LENGTH) {
    my_strncpy(plusAnimal.species, species, (size_t) MAX_SPECIES_LENGTH - 1);
    *(plusAnimal.species + (MAX_SPECIES_LENGTH - 1)) = '\0';
  } else {
    my_strncpy(plusAnimal.species, species, (size_t) MAX_SPECIES_LENGTH);
  }

  plusAnimal.id = id;
  plusAnimal.hungerScale = hungerScale;

  size_t habitatLen = my_strlen(habitat);
  if (habitatLen > MAX_HABITAT_LENGTH) {
    my_strncpy(plusAnimal.habitat, habitat, (size_t) MAX_HABITAT_LENGTH - 1);
    *(plusAnimal.habitat + (MAX_HABITAT_LENGTH - 1)) = '\0';
  } else {
    my_strncpy(plusAnimal.habitat, habitat, (size_t) MAX_HABITAT_LENGTH);
  }


  animals[size] = plusAnimal;
  size++;
  return SUCCESS;
}

/** updateAnimalSpecies
 *
 * @brief updates the species of an existing animal in the array of Animal structs, "animals"
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @param "species" new species of Animal "animal"
 *               NOTE: if the length of species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals" based on its id
 */
int updateAnimalSpecies(struct animal animal, const char *species)
{
  int result = 0;
  int i = 0;
  for (i = 0; i < size; i++) {
    if (isItSame(animals[i], animal) == 1) {
      result = 1;
      break;
    }
  }
  if (result == 0) {
    return FAILURE;
  } else {
      size_t speciesLen  = my_strlen(species);
      if (speciesLen > MAX_SPECIES_LENGTH) {
        my_strncpy(animals[i].species, species, (size_t) MAX_SPECIES_LENGTH - 1);
        *(animals[i].species + (MAX_SPECIES_LENGTH + -1)) = '\0';
      } else {
        my_strncpy(animals[i].species, species, (size_t) MAX_SPECIES_LENGTH);
      }
      return SUCCESS;
  }
}

/** averageHungerScale
* @brief Search for all animals with the same species and find average the hungerScales
* 
* @param "species" Species that you want to find the average hungerScale for
* @return the average hungerScale of the specified species
*         if the species does not exist, return 0.0
*/
double averageHungerScale(const char *species)
{
  int count = 0;
  double sum = 0;
  for (int i = 0; i < size; i++) {
    if (my_strncmp(animals[i].species, species, (size_t) MAX_SPECIES_LENGTH) == 0) {
      sum += animals[i].hungerScale;
      count++;
    }
  }
  if (count == 0) {
    return 0.0;
  } else {
    return (sum / count);
  }
}

/** swapAnimals
 *
 * @brief swaps the position of two Animal structs in the array of Animal structs, "animals"
 *
 * @param "index1" index of the first Animal struct in the array "animals"
 * @param "index2" index of the second Animal struct in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "index1" and/or "index2" are negative numbers
 *         (2) "index1" and/or "index2" are out of bounds of the array "animals"
 */
int swapAnimals(int index1, int index2)
{
  if (index1 < 0 || index1 >= size || index2 < 0 || index2 >= size) {
    return FAILURE;
  }
  struct animal tempAnimal;
  tempAnimal = animals[index1];
  animals[index1] = animals[index2];
  animals[index2] = tempAnimal;
  return SUCCESS;
}

/** compareHabitat
 *
 * @brief compares the two Animals animals' habitats (using ASCII)
 *
 * @param "animal1" Animal struct that exists in the array "animals"
 * @param "animal2" Animal struct that exists in the array "animals"
 * @return negative number if animal1 is less than animal2, positive number if animal1 is greater
 *         than animal2, and 0 if animal1 is equal to animal2
 */
int compareHabitat(struct animal animal1, struct animal animal2)
{
  return my_strncmp(animal1.habitat, animal2.habitat, (size_t) MAX_HABITAT_LENGTH);
}

/** removeAnimal
 *
 * @brief removes Animal in the array of Animal structs, "animals", that has the same species
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals"
 */
int removeAnimal(struct animal animal)
{
  int i = 0;
  for (i = 0; i < size; i++) {
    if (isItSame(animals[i], animal) == 1) {
      break;
    }
  }
  if (i == size) {
    return FAILURE;
  } else {
    for (;i < (size - 1); i++) {
      animals[i] = animals[i + 1];
    }
    size--;
    return SUCCESS;
  }
}

/** sortAnimal
 *
 * @brief using the compareHabitat function, sort the Animals in the array of
 * Animal structs, "animals," by the animals' habitat
 * If two animals have the same habitat, place the hungier animal first
 *
 * @param void
 * @return void
 */
void sortAnimalsByHabitat(void)
{
  for (int i = 0; i < (size - 1); i++) {
    for (int j = 0; j < (size - i - 1); j++) {
      if (compareHabitat(animals[j], animals[j + 1]) > 0) {
        struct animal tempAnimal = animals[j];
        animals[j] = animals[j + 1];
        animals[j + 1] = tempAnimal;
      }
      if (compareHabitat(animals[j], animals[j + 1]) == 0) {
        double firstHunger = animals[j].hungerScale;
        double secondHunger = animals[j + 1].hungerScale;
        if (firstHunger < secondHunger) {
          struct animal tempAnimal = animals[j];
          animals[j] = animals[j + 1];
          animals[j + 1] = tempAnimal;
        }
      }
    }
  }
}
