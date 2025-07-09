# Vanguard

## An Open-Source 2D Weapon system for Godot Games.

Vanguard is a library of simple 2D weapon system catered to hobbyists, begginers and alike. It provides a collection of classes to:
* Build ranged weapons (like guns and bows) using [Ranged](https://github.com/VargaDot/Vanguard/blob/main/blueprints/ranged/ranged.gd).
* Create arrows, bullets and all sorts of projectiles using [Projectile](https://github.com/VargaDot/Vanguard/blob/main/blueprints/projectile/projectile.gd).
* Create explosion, noise and status-effect inducing (poison, burning...) areas with [Field](https://github.com/VargaDot/Vanguard/blob/main/blueprints/field/field.gd).
* Register, equip and unequip weapon modification using [kits](https://github.com/VargaDot/Vanguard/tree/main/kits).
* Build upon a core [Weapon](https://github.com/VargaDot/Vanguard/blob/main/blueprints/weapon/weapon.gd) class and create your own custom classes and weapon types.
* Copy and "mass produce" like [Melee](https://github.com/VargaDot/Vanguard/blob/main/blueprints/melee/melee.tscn), [Hitbox](https://github.com/VargaDot/Vanguard/blob/main/blueprints/hitbox/hitbox.gd) and [Hurtbox](https://github.com/VargaDot/Vanguard/blob/main/blueprints/hurtbox/hurtbox.gd).

## How to use
* Open the blueprints folder.
* Open the desired folder of your choice.
* Right click on the scene.
* Click on "Inherit New Scene".
* Enjoy.

The codebase is pretty small and I've included documentation for everything. If you have a question, feel free to create an issue with the "Question" label.

## Download Guide
Click on "releases" on the right and download

## Found a bug?
See that beautiful (just like you) issue tab? click on it and submit an issue with the red label "bug" and we'll take it from there!

## Known issues
"I shot my weapon and the field doesn't work"
![image](https://github.com/user-attachments/assets/51e59518-6309-498b-80ab-9323f0fb9423)

- you need to set a collisionshape2D manually, i don't know how you'd like your area of field to look like so i left it empty.

## Assets & Libraries
**Sprites used**:
* [Pistol](https://opengameart.org/content/gun-glock-26-gen5-9mm-vector)
* [Sword](https://opengameart.org/content/2d-pixel-weapons)

**Libraries used**:
* [Composer](https://github.com/Sparrowworks/ComposerGodot)
