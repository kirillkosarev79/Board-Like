extends Node

@export var shader_path: String = "res://shades.gdshader"

var shader: Shader
var shader_material: ShaderMaterial

func _ready():

	shader = load(shader_path)
	

	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	

	apply_shader_to_children(self)


func apply_shader_to_children(node: Node):
	for child in node.get_children():
		

		if "Card" in child.name or "Portal" in child.name or child is Sprite2D and not "Minidice" in child.name or child is TextureButton and child.name != 'RollButton'and child.name !='CancelButton' :
			if "Card" in child.name:child.position += Vector2(-5,-5)
			
			var mat := ShaderMaterial.new()
			mat.shader = shader
			
			
			mat.set_shader_parameter("border_scale", 1)
			mat.set_shader_parameter("shadow_scale", 1.2)
			mat.set_shader_parameter("color", Color(0.0, 0.0, 0.0, 0.69))
			
		
			if not "player" in child.name:
				child.material = mat
		
		
		apply_shader_to_children(child)
