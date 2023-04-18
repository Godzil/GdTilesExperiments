@tool

extends MultiMeshInstance3D

@export_group("World settings")
@export var width : int = 20;
@export var height : int = 20
@export_group("Landscape settings")
@export var heightmap : FastNoiseLite;
@export var worldcolor: GradientTexture1D;
@export var underWater: Color;
@export var amplification : float = 1.0;

@export_group("Water settings")

var baseTile = preload("res://Tile.tscn");

func BuildTerrain():
	self.multimesh.instance_count = 0;
	self.multimesh.use_colors = false;
	self.multimesh.use_custom_data = true;
	var mesh_bb = self.multimesh.mesh.get_aabb();
	self.multimesh.instance_count = width * height;
		
	for x in range(width):
		for z in range(height):
			var meshId = z * width + x;
			var tile_x : float = x * mesh_bb.size.x;
			var tile_y : float = 0.0;
			var tile_z : float = z * mesh_bb.size.z * 0.75;
			
			if z & 1:
				tile_x += mesh_bb.size.x / 2;
			
			tile_y = heightmap.get_noise_2d(tile_x, tile_z) * amplification;
			
			var instancePos = Vector3(tile_x, tile_y, tile_z);
			
			self.multimesh.set_instance_transform(meshId, Transform3D(Basis(), instancePos));
			self.multimesh.set_instance_custom_data(meshId, Color(tile_x/width, tile_y, tile_z/height));
			
		
	var terrain_aabb = self.multimesh.get_aabb();
	var terrain_center	= terrain_aabb.get_center();
	
	# $water.set("position", Vector3(terrain_center.x, 0, terrain_center.z));
	# $water.set("scale", Vector3(terrain_aabb.x, 1.0, terrain_aabb.z));
	
	self.set_instance_shader_parameter("colormap", worldcolor);
	self.set_instance_shader_parameter("underwater", underWater);
	self.set_instance_shader_parameter("amplification", amplification);



# Called when the node enters the scene tree for the first time.
func _ready():
	BuildTerrain()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		BuildTerrain()
