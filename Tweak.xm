#include "substrate.h"
#include <string>
#include <cstdio>
#include <chrono>
#include <memory>
#include <vector>
#include <mach-o/dyld.h>
#include <stdint.h>
#include <cstdlib>
#include <sys/mman.h>
#include <sys/stat.h>
#include <random>
#include <cstdint>
#include <unordered_map>
#include <map>
#include <functional>
#include <cmath>
#include <chrono>
#include <libkern/OSCacheControl.h>
#include <cstddef>
#include <tuple>
#include <mach/mach.h>
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>
#include <mach-o/reloc.h>
#include <cstdint>
#include <math.h>

#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

struct TextureUVCoordinateSet;
struct CompoundTag;
struct Material;
struct BlockSource;
struct PlayerInventoryProxy;
struct Item;
struct BlockTessellator;
struct Random;
struct Container {
	void** vtable;
};
struct Dimension;

enum class UseAnimation : unsigned char {
	NONE,
	EAT,
	DRINK,
	BLOCK,
	BOW,
	CAMERA
};

enum class MaterialType : int {
	DEFAULT = 0,
	DIRT,
	WOOD,
	STONE,
	METAL,
	WATER,
	LAVA,
	PLANT,
	DECORATION,
	WOOL = 11,
	BED,
	FIRE,
	SAND,
	DEVICE,
	GLASS,
	EXPLOSIVE,
	ICE,
	PACKED_ICE,
	SNOW,
	CACTUS = 22,
	CLAY,
	PORTAL = 25,
	CAKE,
	WEB,
	CIRCUIT,
	LAMP = 30,
	SLIME
};

enum class ParticleType : int
{
    PARTICLE_POPLE=1,
	PARTICLE_STAR_YELLOW=2,
	PARTICLE_BLCAK_SMOKE=3,
	PARTICLE_WHITE_SMOKE=4,
	PARTICLE_WHITE_SOMKE_2=5,
	PARTICLE_FIRE=6,
	PARTICLE_LAVA_STAR=7,
	PARTICLE_BLACK_SMOKE_2=8,
	PARTICLE_RED_STONE=9,
	PARTICLE_ITEM_BREAK=10,
	PARTICLE_SNOW_BALL=11,
	PARTICLE_EXPLOSION_SMOKE=12,
	PARTICLE_HUGE_EXPLOSION_SMOKE=13,
	PARTICLE_HUGE_FIRE=14,
	PARTICLE_LOVE=15,
	PARTICLE_WATER_VERY_SLOW=17,
	PARTICLE_NEITHER=18,
	PARTICLE_WATER_SLOW=19,
	PARTICLE_WATER_FAST=20,
	PARTICLE_WATER_VERY_FAST=21,
	PARTICLE_LAVA=22,
	PARTICLE_SMOKE_VERY_BLACK=23,
	PARTICLE_POTION=24,
	PARTICLE_POTION_2=25,
	PARTICLE_STAR=26,
	PARTICLE_SMOKE=27,
	PARTICLE_SLIME=28,
	PARTICLE_WATER_MIDDLE=29,
	PARTICLE_VILLAGER_ANGRY=30,
	PARTICLE_GREEN_STAR=31,
	PARTICLE_ENCHANT=32,
	PARTICLE_MUSIC=34,
	PARTICLE_STAR_FAST=35,
	PARTICLE_CARROT=36
};

enum class BlockSoundType : int {
	NORMAL, GRAVEL, WOOD, GRASS, METAL, STONE, CLOTH, GLASS, SAND, SNOW, LADDER, ANVIL, SLIME, SILENT, DEFAULT, UNDEFINED
};

enum class CreativeItemCategory : unsigned char {
	BLOCKS = 1,
	DECORATIONS,
	TOOLS,
	ITEMS
};

struct Block
{
	void** vtable;
	char filler[0x90-8];
	int category;
	char filler2[0x94+0x19+0x90-4];
};

struct LiquidBlock : public Block {};

struct LiquidBlockStatic : public LiquidBlock {
	char filler[0xb8];
};

struct LiquidBlockDynamic : public LiquidBlock {
	char filler[0xc8];
};

struct Item {
    void** vtable; // 0
    uint8_t maxStackSize; // 8
    int idk; // 12
    std::string atlas; // 16
    int frameCount; // 40
    bool animated; // 44
    short itemId; // 46
    std::string name; // 48
    std::string idk3; // 72
    bool isMirrored; // 96
    short maxDamage; // 98
    bool isGlint; // 100
    bool renderAsTool; // 101
    bool stackedByData; // 102
    uint8_t properties; // 103
    int maxUseDuration; // 104
    bool explodeable; // 108
    bool shouldDespawn; // 109
    bool idk4; // 110
    uint8_t useAnimation; // 111
    int creativeCategory; // 112
    float idk5; // 116
    float idk6; // 120
    char buffer[12]; // 124
    TextureUVCoordinateSet* icon; // 136
    void* idk7; // 144
    void* foodComponent; // 152
    void* seedComponent; // 160
    void* cameraComponent; // 168

    struct Tier {
        int level;
        int uses;
        float speed;
        int damage;
        int enchantmentValue;
    };
};

struct WeaponItem : public Item {
    int damage;
    Item::Tier* tier;
};

struct DiggerItem : public Item {
    float speed; // 0xb4
    Item::Tier* tier; // 0xc0
    int attackDamage; // 0xc4
    char filler[0x1E0-0xC4];
};

struct PickaxeItem : public DiggerItem {};

struct BucketItem : public Item {
	char filler[0x1d0];
};

struct BlockItem :public Item {
	char filler[0xB0];
};

struct ItemInstance {
	uint8_t count;
	uint16_t aux;
	CompoundTag* tag;
	Item* item;
	Block* block;
	int idk[3];
};

struct BlockGraphics {
	void** vtable;
	char filler[0x20 - 8];
	int blockShape;
	char filler2[0x3C0 - 0x20 - 4];
};

struct LevelData {
	char filler[48];
	std::string levelName;
	char filler2[44];
	int time;
	char filler3[144];
	int gameType;
	int difficulty;
};

struct Level {
	char filler[160];
	LevelData* data;
};

struct Entity {
	char filler[64];
	Level* level;
	char filler2[104];
	BlockSource* region;
};

struct Mob :public Entity {};

struct Player :public Entity {
    char filler[0x1053 - sizeof(Entity)];
    bool isCreative;
    char filler2[0x11e8 - 0x1053 - 1];
    PlayerInventoryProxy* inventory;
};

struct MobEffectInstance {
  unsigned int id;
  int duration;
  int amplifier;
  bool ambient;
  bool noCounter;
  bool showParticles;
};

struct Vec3 {
	float x, y, z;

	Vec3(float _x, float _y, float _z) : x(_x), y(_y), z(_z) {}

	float distanceTo(float _x, float _y, float _z) const {

		return (float) sqrt((x - _x) * (x - _x) + (y - _y) * (y - _y) + (z - _z) * (z - _z));
	}

	float distanceTo(Vec3 const& v) const {

		return distanceTo(v.x, v.y, v.z);
	}

	bool operator!=(Vec3 const& other) const {
		return x == other.x || y == other.y || z == other.z;
	}

	bool operator==(Vec3 const& other) const {
        return x == other.x && y == other.y && z == other.z;
    }

    Vec3 operator+(Vec3 const& v) const {
    	return {this->x + v.x, this->y + v.y, this->z + v.z};
    }

    Vec3 operator-(Vec3 const& v) const {
    	return {this->x - v.x, this->y - v.y, this->z - v.z};
    }

    Vec3 operator-() const {
    	return {-x, -y, -z};
    }

    Vec3 operator*(float times) const {
    	return {x * times, y * times, z * times};
    };

    Vec3 operator/(float value) const {
    	return {x / value, y / value, z / value};
    };

    Vec3 operator*(Vec3 const& v) const {
    	return {x * v.x, y * v.y, z * v.z};
    }
};

Vec3 operator*(float a, Vec3 b) {
	return b * a;
}

struct BlockPos {
	int x, y, z;

	BlockPos() : BlockPos(0, 0, 0) {}

    BlockPos(int x, int y, int z) : x(x), y(y), z(z) {}

    BlockPos(Vec3 const &v) : x((int) floorf(v.x)), y((int) floorf(v.y)), z((int) floorf(v.z)) {}

    BlockPos(BlockPos const &blockPos) : BlockPos(blockPos.x, blockPos.y, blockPos.z) {}

    bool operator==(BlockPos const &pos) const {
        return x == pos.x && y == pos.y && z == pos.z;
    }
    bool operator!=(BlockPos const &pos) const {
        return x != pos.x || y != pos.y || z != pos.z;
    }
    bool operator<(BlockPos const& pos) const {
        return std::make_tuple(x, y, z) < std::make_tuple(pos.x, pos.y, pos.z);
    }

	BlockPos getSide(unsigned char side) const {
        switch (side) {
            case 0:
                return {x, y - 1, z};
            case 1:
                return {x, y + 1, z};
            case 2:
                return {x, y, z - 1};
            case 3:
                return {x, y, z + 1};
            case 4:
                return {x - 1, y, z};
            case 5:
                return {x + 1, y, z};
            default:
                return {x, y, z};
        }
	}
};

struct BlockID {
	static BlockID AIR;

	unsigned char id;

	BlockID() : id(0) {}
	BlockID(unsigned char id) : id(id) {}
	BlockID(const BlockID& other) {id = other.id;}
};

struct FullBlock {
    static FullBlock AIR;

    BlockID id;
    unsigned char aux;

    FullBlock() : id(0), aux(0) {};
    FullBlock(BlockID tileId, unsigned char aux_) : id(tileId), aux(aux_) {}
    FullBlock(FullBlock const& b) : id(b.id), aux(b.aux) {}
};

unsigned int (*Random$genrand_int32)(Random*);

struct Random {
	unsigned int _seed;
	unsigned int _mt[624];
	int _mti;
	bool haveNextNextGaussian;
	float nextNextGaussian;

	Random(unsigned int seed)
	{
		setSeed(seed);
	}

	void setSeed(unsigned int seed)
	{
		_seed = seed;
		_mt[0] = seed;
		haveNextNextGaussian = false;
		nextNextGaussian = 0.0F;

		unsigned int help = seed;
		unsigned int multiplier = 0x6C078965;
		for(int i = 1; i < 624; ++i)
		{
			help ^= (help >> 30);
			help = (help * multiplier) + i;
			_mt[i] = help;
		}

		_mti = 624;
	}

	float nextFloat()
	{
		return (float)((double)Random$genrand_int32(this)/UINT_MAX);
	}

	float nextFloat(float range)
	{
		return fmod(nextFloat(),range);
	}

	int nextInt(int max)
	{
		return Random$genrand_int32(this)%max;
	}

	bool nextBool()
	{
		return Random$genrand_int32(this)%2;
	}

	bool nextBool(int max)
	{
		return nextInt(max)==nextInt(max);
	}
};

enum class HitResultType : int {
    Tile = 0x0,
    Entity = 0x1,
    EntityOutOfRange = 0x2,
    NoHit = 0x3,
};

struct HitResult {
  HitResultType type;
  char side;
  BlockPos blockPos;
  Vec3 vec3;
  Entity* entity;
  char filler[69 - 40];
};

enum class LevelSoundEvent : int {
	BucketFillWater = 73,
	BucketEmptyWater = 75
};

enum class EntityType : int {
	Undefined = 1
};

enum class EntityLocation : int {
	Feet,
	Body,
	WeaponAttachPoint,
	Head,
	DropAttachPoint,
	ExplosionPoint,
	Eyes,
	BreathingPoint,
	Mouth
};

enum class LevelEvent : int {
	SoundClick = 1000
};

namespace Json { class Value; }

static Item*** Item$mItems;

Block** Block$mBlocks;
BlockGraphics** BlockGraphics$mBlocks;

static std::unordered_map<std::string, Block*>* Block$mBlockLookupMap;

BlockItem*(*BlockItem$BlockItem)(BlockItem*, std::string const&, int);

Item*(*Item$Item)(Item*, std::string const&, short);

ItemInstance*(*ItemInstance$ItemInstance)(ItemInstance*, int, int, int);

Item*(*Item$setIcon)(Item*, std::string const&, int);
Item*(*Item$setMaxStackSize)(Item*, unsigned char);
void(*Item$addCreativeItem)(const ItemInstance&);

Block*(*Block$Block)(Block*, std::string const&, int, Material const&);
LiquidBlockDynamic*(*LiquidBlockDynamic$LiquidBlockDynamic)(LiquidBlockDynamic*, std::string const&, int, Material const&);
LiquidBlockStatic*(*LiquidBlockStatic$LiquidBlockStatic)(LiquidBlockStatic*, std::string const&, int, BlockID, Material const&);

Material&(*Material$getMaterial)(MaterialType);

BlockGraphics*(*BlockGraphics$BlockGraphics)(BlockGraphics*, std::string const&);
void(*BlockGraphics$setCarriedTextureItem)(BlockGraphics*, std::string const&, std::string const&, std::string const&);
void(*BlockGraphics$setTextureItem)(BlockGraphics*, std::string const&, std::string const&, std::string const&, std::string const&, std::string const&, std::string const&);

Level&(*BlockSource$getLevel)(BlockSource*);

void(*Level$addParticle)(Level*, ParticleType, Vec3 const&, Vec3 const&, int);
void(*Level$broadcastSoundEvent)(Level*, BlockSource&, LevelSoundEvent, Vec3 const&, int, EntityType, bool, bool);
void(*Level$broadcastLevelEvent)(Level*, LevelEvent, Vec3 const&, int, Player*);

void(*Mob$addEffect)(Mob*, MobEffectInstance const&);

MobEffectInstance*(*MobEffectInstance$MobEffectInstance)(MobEffectInstance*, int, int);

BlockSource&(*Entity$getRegion)(Entity*);
Vec3(*Entity$getInterpolatedPosition)(Entity*, float);
Vec3(*Entity$getViewVector)(Entity*, float);
Level*(*Entity$getLevel)(Entity*);
Vec3(*Entity$getAttachPos)(Entity*, EntityLocation);

void(*BlockSource$setBlockAndData)(BlockSource*, BlockPos const&, FullBlock, int);
FullBlock(*BlockSource$getBlockAndData)(BlockSource*, BlockPos const&);
HitResult(*BlockSource$clip)(BlockSource*, Vec3 const&, Vec3 const&, bool, bool, int, bool);
Dimension*(*BlockSource$getDimension)(BlockSource*);

bool(*Dimension$isUltraWarm)(Dimension*);

bool(*PlayerInventoryProxy$add)(PlayerInventoryProxy*, ItemInstance&, bool);

bool(*BucketItem$_emptyBucket)(BucketItem*, BlockSource*, FullBlock, BlockPos const&);

bool(*Container$addItemToFirstEmptySlot)(Container*, ItemInstance*);

static void Container$removeItem(Container* container, int slot, int count) {
    return ((void (*)(Container*, int, int)) container->vtable[8])(container, slot, count);
}

static void(*DispenserBlock$ejectItem)(BlockSource&, Vec3 const&, signed char, ItemInstance*);

int onsenBucket = 2000;
Item* onsenBucketPtr;

int onsenDynamic = 238;
BlockItem* onsenDynamicItemPtr;
LiquidBlockDynamic* onsenDynamicBlockPtr;
BlockGraphics* onsenDynamicGraphicsPtr;

int onsenStatic = 239;
BlockItem* onsenStaticItemPtr;
LiquidBlockStatic* onsenStaticBlockPtr;
BlockGraphics* onsenStaticGraphicsPtr;

bool fromTesellateLiquid = false;

static uintptr_t** VTAppPlatformiOS;

static uintptr_t** VTItem;

static bool (*_File$exists)(std::string const&);
static bool File$exists(std::string const& path) {
	if(path.find("minecraftpe.app/data/resourcepacks/vanilla/client/textures/items/bucket_onsen.png") != std::string::npos || path.find("minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_placeholder.png") != std::string::npos || path.find("minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_still.png") != std::string::npos ||path.find("minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_flow.png") != std::string::npos)
		return true;

	return _File$exists(path);
}

static std::string (*_AppPlatformiOS$readAssetFile)(uintptr_t*, std::string const&);
static std::string AppPlatformiOS$readAssetFile(uintptr_t* self, std::string const& str) {

	if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/items/bucket_onsen.png"))
        return _AppPlatformiOS$readAssetFile(self, "/Library/Application Support/addliquid/bucket_onsen.png");
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_placeholder.png"))
        return _AppPlatformiOS$readAssetFile(self, "/Library/Application Support/addliquid/onsen_placeholder.png");
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_still.png"))
        return _AppPlatformiOS$readAssetFile(self, "/Library/Application Support/addliquid/onsen_still.png");
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/blocks/onsen_flow.png"))
        return _AppPlatformiOS$readAssetFile(self, "/Library/Application Support/addliquid/onsen_flow.png");

    std::string content = _AppPlatformiOS$readAssetFile(self, str);
    
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/item_texture.json")) {
        NSString *jsonString = [NSString stringWithUTF8String:content.c_str()];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

        NSMutableDictionary *jsonTextureData = [jsonDict objectForKey:@"texture_data"];
        [jsonTextureData setObject:@{
            @"textures": @[@"textures/items/bucket_onsen"]
        } forKey:@"bucket_onsen"];
       
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&jsonError];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        content = std::string([jsonString UTF8String]);
    }
    
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/terrain_texture.json")) {
        NSString *jsonString = [NSString stringWithUTF8String:content.c_str()];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

        NSMutableDictionary *jsonTextureData = [jsonDict objectForKey:@"texture_data"];
        [jsonTextureData setObject:@{
            @"textures": @[@"textures/blocks/onsen_placeholder"]
        } forKey:@"still_onsen"];
        [jsonTextureData setObject:@{
            @"textures": @[@"textures/blocks/onsen_placeholder"],
            @"quad": @1
        } forKey:@"flowing_onsen"];
       
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&jsonError];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        content = std::string([jsonString UTF8String]);
    }
    if (strstr(str.c_str(), "minecraftpe.app/data/resourcepacks/vanilla/client/textures/flipbook_textures.json")) {
        NSString *jsonString = [NSString stringWithUTF8String:content.c_str()];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

        [jsonArr addObject:@{
            @"flipbook_texture": @"textures/blocks/onsen_still",
            @"atlas_tile": @"still_onsen",
            @"ticks_per_frame": @2
        }];
        [jsonArr addObject:@{
            @"flipbook_texture": @"textures/blocks/onsen_flow",
            @"atlas_tile": @"flowing_onsen",
            @"replicate": @2
        }];
       
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:&jsonError];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        content = std::string([jsonString UTF8String]);
    }
    return content;
}

static bool (*_Material$isType)(Material*, int);
static bool Material$isType(Material* self, int type) {
	if(fromTesellateLiquid && type == 5)
		return false;
	return _Material$isType(self, type);
}

static void (*_BlockTessellator$tessellateLiquidInWord)(BlockTessellator*, LiquidBlock&, BlockPos const&, unsigned char);
static void BlockTessellator$tessellateLiquidInWord(BlockTessellator* self, LiquidBlock& liquid, BlockPos const& pos, unsigned char c1) {

	fromTesellateLiquid = true;

	_BlockTessellator$tessellateLiquidInWord(self, liquid, pos, c1);

	fromTesellateLiquid = false;
}

static void (*_Item$initCreativeItems)();
static void Item$initCreativeItems() {
	_Item$initCreativeItems();


	ItemInstance inst_onsen_bucket;
	ItemInstance$ItemInstance(&inst_onsen_bucket, onsenBucket, 1, 0);
	Item$addCreativeItem(inst_onsen_bucket);
	

	ItemInstance inst_onsen_dynamic;
	ItemInstance$ItemInstance(&inst_onsen_dynamic, onsenDynamic, 1, 0);
	Item$addCreativeItem(inst_onsen_dynamic);

	ItemInstance inst_onsen_static;
	ItemInstance$ItemInstance(&inst_onsen_static, onsenStatic, 1, 0);
	Item$addCreativeItem(inst_onsen_static);	
}

static void (*_Item$registerItems)();
static void Item$registerItems() {
	_Item$registerItems();


	onsenBucketPtr = new Item();
	Item$Item(onsenBucketPtr, "onsen_bucket", onsenBucket - 0x100);
	Item$mItems[1][onsenBucket] = onsenBucketPtr;
	onsenBucketPtr->creativeCategory = 3;
	Item$setMaxStackSize(onsenBucketPtr, 1);
	
}

static void (*_Item$initClientData)();
static void Item$initClientData() {
	_Item$initClientData();

	Item$setIcon(onsenBucketPtr, "bucket_onsen", 0);
}

static void (*_Item$addBlockItems)();
static void Item$addBlockItems() {
	_Item$addBlockItems();

	onsenDynamicItemPtr = new BlockItem();
	BlockItem$BlockItem(onsenDynamicItemPtr, "flowing_onsen", onsenDynamic - 0x100);
	Item$mItems[1][onsenDynamic] = onsenDynamicItemPtr;

	onsenStaticItemPtr = new BlockItem();
	BlockItem$BlockItem(onsenStaticItemPtr, "onsen", onsenStatic - 0x100);
	Item$mItems[1][onsenStatic] = onsenStaticItemPtr;
}

static void (*_Block$initBlocks)();
static void Block$initBlocks() {
	_Block$initBlocks();

	onsenDynamicBlockPtr = new LiquidBlockDynamic();
	LiquidBlockDynamic$LiquidBlockDynamic(onsenDynamicBlockPtr, "flowing_onsen", onsenDynamic, Material$getMaterial(MaterialType::WATER));
	Block$mBlocks[onsenDynamic] = onsenDynamicBlockPtr;
	(*Block$mBlockLookupMap)["flowing_onsen"] = onsenDynamicBlockPtr;
	//onsenDynamicBlockPtr->category = 1;

	onsenStaticBlockPtr = new LiquidBlockStatic();
	LiquidBlockStatic$LiquidBlockStatic(onsenStaticBlockPtr, "onsen", onsenStatic, BlockID(onsenDynamic), Material$getMaterial(MaterialType::WATER));
	Block$mBlocks[onsenStatic] = onsenStaticBlockPtr;
	(*Block$mBlockLookupMap)["onsen"] = onsenStaticBlockPtr;
	//onsenStaticBlockPtr->category = 1;
}

static void (*_BlockGraphics$initBlocks)();
static void BlockGraphics$initBlocks() {
	_BlockGraphics$initBlocks();

	onsenDynamicGraphicsPtr = new BlockGraphics();
	BlockGraphics$BlockGraphics(onsenDynamicGraphicsPtr, "flowing_onsen");
	BlockGraphics$mBlocks[onsenDynamic] = onsenDynamicGraphicsPtr;
	onsenDynamicGraphicsPtr->blockShape = 4;
	BlockGraphics$setCarriedTextureItem(onsenDynamicGraphicsPtr, "flowing_onsen", "flowing_onsen", "flowing_onsen");
	BlockGraphics$setTextureItem(onsenDynamicGraphicsPtr, "flowing_onsen", "flowing_onsen", "flowing_onsen", "flowing_onsen", "flowing_onsen", "flowing_onsen");

	onsenStaticGraphicsPtr = new BlockGraphics();
	BlockGraphics$BlockGraphics(onsenStaticGraphicsPtr, "onsen");
	BlockGraphics$mBlocks[onsenStatic] = onsenStaticGraphicsPtr;
	onsenStaticGraphicsPtr->blockShape = 4;
	BlockGraphics$setCarriedTextureItem(onsenStaticGraphicsPtr, "still_onsen", "still_onsen", "still_onsen");
	BlockGraphics$setTextureItem(onsenStaticGraphicsPtr, "still_onsen", "still_onsen", "still_onsen", "still_onsen", "still_onsen", "still_onsen");
}

static void (*_LiquidBlock$animateTick)(LiquidBlock*, BlockSource&, BlockPos const&, Random&);
static void LiquidBlock$animateTick(LiquidBlock* self, BlockSource& source, BlockPos const& pos, Random& random) {
	if(self == onsenDynamicBlockPtr || self == onsenStaticBlockPtr) {
		if(random.nextInt(5) == 0) {
			float x0 = (float)pos.x + random.nextInt(10) * 0.1f;
			float y0 = (float)pos.y + random.nextInt(5) * 0.1f;
			float z0 = (float)pos.z + random.nextInt(10) * 0.1f;

			Level$addParticle(&BlockSource$getLevel(&source), ParticleType::PARTICLE_WHITE_SOMKE_2, Vec3(x0, y0, z0), Vec3(0.f, 0.1f, 0.0f), random.nextInt(10));
		}
	}
}

static void (*_LiquidBlock$handleEntityInside)(LiquidBlock*, BlockSource&, BlockPos const&, Entity*, Vec3&);
static void LiquidBlock$handleEntityInside(LiquidBlock* self, BlockSource& source, BlockPos const& pos, Entity* entity, Vec3& vec) {
	if(self == onsenDynamicBlockPtr || self == onsenStaticBlockPtr) {
		MobEffectInstance onseneffect;
		MobEffectInstance$MobEffectInstance(&onseneffect, 10, 1200);
		Mob$addEffect((Mob*)entity, onseneffect);
	}
}

bool emptyBucketImpl(Item* self, BlockSource* region, BlockPos pos) {
  Dimension* dim = BlockSource$getDimension(region);
  if (Dimension$isUltraWarm(dim)) {
    return BucketItem$_emptyBucket((BucketItem*) self, region, {8, 0}, pos);
  } else {
    return BucketItem$_emptyBucket((BucketItem*) self, region, {onsenDynamic, 0}, pos);
  }
}

static bool (*_BucketItem$useOn)(BucketItem*, ItemInstance*, Player*, int, int, int, signed char, float, float, float);
static bool BucketItem$useOn(BucketItem* self, ItemInstance* item, Player* player, int x, int y, int z, signed char side, float vx, float vy, float vz) {
  FullBlock block = BlockSource$getBlockAndData(&Entity$getRegion(player), {x, y, z});
  if (block.id.id == onsenDynamic || block.id.id == onsenStatic) {
    if (!player->isCreative)
      item->count -= 1;
    ItemInstance filledBucketInst;
    ItemInstance$ItemInstance(&filledBucketInst, onsenBucket, 1, 0);
    if (item->count > 0)
      PlayerInventoryProxy$add(player->inventory, filledBucketInst, true);
    else
      *item = filledBucketInst;
  BlockSource$setBlockAndData(&Entity$getRegion(player), {x, y, z}, {{0}, 0}, 3);
  Level$broadcastSoundEvent(Entity$getLevel(player), Entity$getRegion(player), LevelSoundEvent::BucketFillWater, Entity$getAttachPos(player, EntityLocation::Feet), -1, EntityType::Undefined, 0, 0);
  return true;
  }
  return _BucketItem$useOn(self, item, player, x, y, z, side, vx, vy, vz);
}

static bool (*_Item$useOn)(Item*, ItemInstance*, Player*, int, int, int, signed char, float, float, float);
static bool Item$useOn(Item* self, ItemInstance* item, Player* player, int x, int y, int z, char side, float vx, float vy, float vz) {
  if (item->item != nullptr && item->item->itemId == onsenBucket) {
    BlockSource& region = Entity$getRegion(player);
    Dimension* dim = BlockSource$getDimension(&region);
    Vec3 position = Entity$getInterpolatedPosition(player, 1.f);
    Vec3 dir = Entity$getViewVector(player, 1.f);
    HitResult hitResult = BlockSource$clip(&region, position, position + 5.f * dir, false, true, 200, false);
    if (hitResult.type == HitResultType::EntityOutOfRange || hitResult.type == HitResultType::NoHit)
      return false;
    if (!emptyBucketImpl((BucketItem*) self, &region, hitResult.blockPos.getSide(hitResult.side)))
      return false;
  if (!player->isCreative)
      item->count -= 1;
    ItemInstance emptyBucketInst;
    ItemInstance$ItemInstance(&emptyBucketInst, 325, 1, 0);
    if (item->count > 0)
      PlayerInventoryProxy$add(player->inventory, emptyBucketInst, true);
    else
      *item = emptyBucketInst;
  	if (!Dimension$isUltraWarm(dim))
    Level$broadcastSoundEvent(Entity$getLevel(player), region, LevelSoundEvent::BucketEmptyWater, Entity$getAttachPos(player, EntityLocation::Feet), -1, EntityType::Undefined, 0, 0);
    return true;
  }
  return _Item$useOn(self, item, player, x, y, z, side, vx, vy, vz);
}

static bool (*_BucketItem$dispense)(BucketItem*, BlockSource&, Container&, int, Vec3 const&, signed char);
static bool BucketItem$dispense(BucketItem* self, BlockSource& region, Container& container, int i, Vec3 const& pos, signed char i2) {
  FullBlock block = BlockSource$getBlockAndData(&region, BlockPos(pos));
  if(block.aux != 0)
  	return false;
  if (block.id.id == onsenDynamic || block.id.id == onsenStatic) {
    BlockSource$setBlockAndData(&region, BlockPos(pos), {{0}, 0}, 3);
    Level$broadcastLevelEvent(&BlockSource$getLevel(&region), LevelEvent::SoundClick, pos, 1000, nullptr);
    Container$removeItem(&container, i, 1);
    ItemInstance filledBucketInst;
    ItemInstance$ItemInstance(&filledBucketInst, onsenBucket, 1, 0);
    if (!Container$addItemToFirstEmptySlot(&container, &filledBucketInst))
      DispenserBlock$ejectItem(region, pos, i2, &filledBucketInst);
    return true;
  }
  return _BucketItem$dispense(self, region, container, i, pos, i2);
}

static bool (*_Item$dispense)(Item*, BlockSource&, Container&, int, Vec3 const&, signed char);
static bool Item$dispense(Item* self, BlockSource& region, Container& container, int i, Vec3 const& pos, signed char i2) {
  if (self != nullptr && self->itemId == onsenBucket) {
    if (!emptyBucketImpl((BucketItem*) self, &region, BlockPos(pos)))
      return false;
    Level$broadcastLevelEvent(&BlockSource$getLevel(&region), LevelEvent::SoundClick, pos, 1000, nullptr);
    Container$removeItem(&container, i, 1);
    ItemInstance emptyBucketInst;
    ItemInstance$ItemInstance(&emptyBucketInst, 325, 1, 0);
    if (!Container$addItemToFirstEmptySlot(&container, &emptyBucketInst))
      DispenserBlock$ejectItem(region, pos, i2, &emptyBucketInst);
    return true;
  }
  return _Item$dispense(self, region, container, i, pos, i2);
}

%ctor {
	Random$genrand_int32 = (unsigned int(*)(Random*))(0x1000ec430 + _dyld_get_image_vmaddr_slide(0));

	VTAppPlatformiOS = (uintptr_t**)(0x1011695f0 + _dyld_get_image_vmaddr_slide(0));
	_AppPlatformiOS$readAssetFile = (std::string(*)(uintptr_t*, std::string const&)) VTAppPlatformiOS[58];
	VTAppPlatformiOS[58] = (uintptr_t*)&AppPlatformiOS$readAssetFile;

	Item$mItems = (Item***)(0x1012ae238 + _dyld_get_image_vmaddr_slide(0));

	Block$mBlocks = (Block**)(0x1012d1860 + _dyld_get_image_vmaddr_slide(0));
	BlockGraphics$mBlocks = (BlockGraphics**)(0x10126a100 + _dyld_get_image_vmaddr_slide(0));

	Block$mBlockLookupMap = (std::unordered_map<std::string, Block*>*)(0x1012d2078 + _dyld_get_image_vmaddr_slide(0));

	BlockItem$BlockItem = (BlockItem*(*)(BlockItem*, std::string const&, int))(0x1007281e0 + _dyld_get_image_vmaddr_slide(0));

	Item$Item = (Item*(*)(Item*, std::string const&, short))(0x10074689c + _dyld_get_image_vmaddr_slide(0));

	ItemInstance$ItemInstance = (ItemInstance*(*)(ItemInstance*, int, int, int))(0x100756c70 + _dyld_get_image_vmaddr_slide(0));

	Item$setIcon = (Item*(*)(Item*, std::string const&, int))(0x100746b0c + _dyld_get_image_vmaddr_slide(0));
	Item$setMaxStackSize = (Item*(*)(Item*, unsigned char))(0x100746a88 + _dyld_get_image_vmaddr_slide(0));
	Item$addCreativeItem = (void(*)(const ItemInstance&))(0x100745f10 + _dyld_get_image_vmaddr_slide(0));

	Block$Block = (Block*(*)(Block*, std::string const&, int, Material const&))(0x1007d7e20 + _dyld_get_image_vmaddr_slide(0));
	LiquidBlockDynamic$LiquidBlockDynamic = (LiquidBlockDynamic*(*)(LiquidBlockDynamic*, std::string const&, int, Material const&))(0x100811798 + _dyld_get_image_vmaddr_slide(0));
	LiquidBlockStatic$LiquidBlockStatic = (LiquidBlockStatic*(*)(LiquidBlockStatic*, std::string const&, int, BlockID, Material const&))(0x100812540 + _dyld_get_image_vmaddr_slide(0));

	Material$getMaterial = (Material&(*)(MaterialType))(0x1008c6e74 + _dyld_get_image_vmaddr_slide(0));

	BlockGraphics$BlockGraphics = (BlockGraphics*(*)(BlockGraphics*, std::string const&))(0x100388338 + _dyld_get_image_vmaddr_slide(0));
	BlockGraphics$setCarriedTextureItem = (void(*)(BlockGraphics*, std::string const&, std::string const&, std::string const&))(0x100382f0c + _dyld_get_image_vmaddr_slide(0));
	BlockGraphics$setTextureItem = (void(*)(BlockGraphics*, std::string const&, std::string const&, std::string const&, std::string const&, std::string const&, std::string const&))(0x1003829c8 + _dyld_get_image_vmaddr_slide(0));

	BlockSource$getLevel = (Level&(*)(BlockSource*))(0x1007994a0 + _dyld_get_image_vmaddr_slide(0));

	Level$addParticle = (void(*)(Level*, ParticleType, Vec3 const&, Vec3 const&, int))(0x1007a7bec + _dyld_get_image_vmaddr_slide(0));
	Level$broadcastSoundEvent = (void(*)(Level*, BlockSource&, LevelSoundEvent, Vec3 const&, int, EntityType, bool, bool))(0x1007a780c + _dyld_get_image_vmaddr_slide(0));
	Level$broadcastLevelEvent = (void(*)(Level*, LevelEvent, Vec3 const&, int, Player*))(0x1007a7664 + _dyld_get_image_vmaddr_slide(0));

	Mob$addEffect = (void(*)(Mob*, MobEffectInstance const&))(0x1006a4928 + _dyld_get_image_vmaddr_slide(0));

	MobEffectInstance$MobEffectInstance = (MobEffectInstance*(*)(MobEffectInstance*, int, int))(0x10064d488 + _dyld_get_image_vmaddr_slide(0));

	Entity$getRegion = (BlockSource&(*)(Entity*))(0x100658034 + _dyld_get_image_vmaddr_slide(0));
	Entity$getInterpolatedPosition = (Vec3(*)(Entity*, float))(0x10065a258 + _dyld_get_image_vmaddr_slide(0));
	Entity$getViewVector = (Vec3(*)(Entity*, float))(0x10065a330 + _dyld_get_image_vmaddr_slide(0));
	Entity$getLevel = (Level*(*)(Entity*))(0x100657df8 + _dyld_get_image_vmaddr_slide(0));
	Entity$getAttachPos = (Vec3(*)(Entity*, EntityLocation))(0x100659704 + _dyld_get_image_vmaddr_slide(0));

	BlockSource$setBlockAndData = (void(*)(BlockSource*, BlockPos const&, FullBlock, int))(0x10079b320 + _dyld_get_image_vmaddr_slide(0));
	BlockSource$getBlockAndData = (FullBlock(*)(BlockSource*, BlockPos const&))(0x10079a1fc + _dyld_get_image_vmaddr_slide(0));
	BlockSource$clip = (HitResult(*)(BlockSource*, Vec3 const&, Vec3 const&, bool, bool, int, bool))(0x10079ddf4 + _dyld_get_image_vmaddr_slide(0));
	BlockSource$getDimension = (Dimension*(*)(BlockSource*))(0x10079975c + _dyld_get_image_vmaddr_slide(0));

	Dimension$isUltraWarm = (bool(*)(Dimension*))(0x100854820 + _dyld_get_image_vmaddr_slide(0));

	PlayerInventoryProxy$add = (bool(*)(PlayerInventoryProxy*, ItemInstance&, bool))(0x1007161fc + _dyld_get_image_vmaddr_slide(0));

	BucketItem$_emptyBucket = (bool(*)(BucketItem*, BlockSource*, FullBlock, BlockPos const&))(0x10072b180 + _dyld_get_image_vmaddr_slide(0));

	Container$addItemToFirstEmptySlot = (bool(*)(Container*, ItemInstance*))(0x10060ee9c + _dyld_get_image_vmaddr_slide(0));

	DispenserBlock$ejectItem = (void(*)(BlockSource&, Vec3 const&, signed char, ItemInstance*))(0x1008004e0 + _dyld_get_image_vmaddr_slide(0));

	MSHookFunction((void*)(0x1008c6de8 + _dyld_get_image_vmaddr_slide(0)), (void*)&Material$isType, (void**)&_Material$isType);
	MSHookFunction((void*)(0x10039141c + _dyld_get_image_vmaddr_slide(0)), (void*)&BlockTessellator$tessellateLiquidInWord, (void**)&_BlockTessellator$tessellateLiquidInWord);

	MSHookFunction((void*)(0x1005316ec + _dyld_get_image_vmaddr_slide(0)), (void*)&File$exists, (void**)&_File$exists);

	MSHookFunction((void*)(0x100734d00 + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$initCreativeItems, (void**)&_Item$initCreativeItems);
	MSHookFunction((void*)(0x100733348 + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$registerItems, (void**)&_Item$registerItems);
	MSHookFunction((void*)(0x10074242c + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$initClientData, (void**)&_Item$initClientData);
	MSHookFunction((void*)(0x100745f6c + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$addBlockItems, (void**)&_Item$addBlockItems);
	MSHookFunction((void*)(0x1007d451c + _dyld_get_image_vmaddr_slide(0)), (void*)&Block$initBlocks, (void**)&_Block$initBlocks);
	MSHookFunction((void*)(0x1003845e0 + _dyld_get_image_vmaddr_slide(0)), (void*)&BlockGraphics$initBlocks, (void**)&_BlockGraphics$initBlocks);

	MSHookFunction((void*)(0x100810994 + _dyld_get_image_vmaddr_slide(0)), (void*)&LiquidBlock$animateTick, (void**)&_LiquidBlock$animateTick);
	MSHookFunction((void*)(0x100810448 + _dyld_get_image_vmaddr_slide(0)), (void*)&LiquidBlock$handleEntityInside, (void**)&_LiquidBlock$handleEntityInside);

	MSHookFunction((void*)(0x10072ac4c + _dyld_get_image_vmaddr_slide(0)), (void*)&BucketItem$useOn, (void**)&_BucketItem$useOn);
	MSHookFunction((void*)(0x100746be0 + _dyld_get_image_vmaddr_slide(0)), (void*)&Item$useOn, (void**)&_Item$useOn);
	MSHookFunction((void*)(0x10072b470 + _dyld_get_image_vmaddr_slide(0)), (void*)&BucketItem$dispense, (void**)&_BucketItem$dispense);

	VTItem = (uintptr_t**)(0x101141478 + _dyld_get_image_vmaddr_slide(0));
	_Item$dispense = (bool(*)(Item*, BlockSource&, Container&, int, Vec3 const&, signed char)) VTItem[38];
	VTItem[38] = (uintptr_t*)&Item$dispense;
}