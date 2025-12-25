import 'package:equatable/equatable.dart';
import 'new_project_state.dart';

abstract class NewProjectEvent extends Equatable {
  const NewProjectEvent();

  @override
  List<Object?> get props => [];
}

class TitleChanged extends NewProjectEvent {
  final String title;
  const TitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class DescriptionChanged extends NewProjectEvent {
  final String description;
  const DescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class CoverImageChanged extends NewProjectEvent {
  final String? imagePath;
  const CoverImageChanged(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class TextContentChanged extends NewProjectEvent {
  final String text;
  const TextContentChanged(this.text);

  @override
  List<Object?> get props => [text];
}

class CategoryChanged extends NewProjectEvent {
  final String category;
  const CategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class AddParticipants extends NewProjectEvent {
  final List<ProjectParticipant> participants;
  const AddParticipants(this.participants);

  @override
  List<Object?> get props => [participants];
}

class AddParticipant extends NewProjectEvent {
  final String name;
  final String avatarUrl;
  const AddParticipant({required this.name, required this.avatarUrl});

  @override
  List<Object?> get props => [name, avatarUrl];
}

class RemoveParticipant extends NewProjectEvent {
  final String name;
  const RemoveParticipant(this.name);

  @override
  List<Object?> get props => [name];
}

class PublishProject extends NewProjectEvent {}
