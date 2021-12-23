part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();
}

class AppLoaded extends PatientEvent{
  @override
  List<Object?> get props => throw UnimplementedError();
}
