/// Represents the current phase of the basketball upload interaction.
enum ShotState {
  aiming, // User is aiming the trajectory
  flying, // PDF document is traveling along the arc
  scored, // Basket made successfully
  missed, // Shot missed the hoop
  uploading, // Upload progress bar running
  completed, // Upload finished successfully
}
