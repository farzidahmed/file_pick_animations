/// Represents the current phase of the basketball upload interaction.
enum ShotState {
  idle, // Waiting for user to select a file
  aiming, // File selected, user is aiming the trajectory
  flying, // PDF document is traveling along the arc
  scored, // Basket made successfully
  missed, // Shot missed the hoop
  uploading, // Upload progress bar running
  completed, // Upload finished successfully
}
