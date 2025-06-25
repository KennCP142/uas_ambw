part of 'activity.dart';

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 0;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Activity(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      time: fields[3] as DateTime,
      category: fields[4] as String,
      isCompleted: fields[5] as bool,
      userId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
