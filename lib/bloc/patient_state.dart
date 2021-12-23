part of 'patient_bloc.dart';

abstract class PatientState extends Equatable {
  const PatientState();
}

class PatientInitial extends PatientState {
  @override
  List<Object> get props => [];
}
