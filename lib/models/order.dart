class TimelineStep {
  final String step;
  final String label;
  final String? timestamp;
  final bool active;

  const TimelineStep({
    required this.step,
    required this.label,
    this.timestamp,
    this.active = false,
  });
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class Order {
  final String id;
  final String status;
  final String estimatedArrival;
  final int eta;
  final List<OrderItem> dishes;
  final double total;
  final String driverId;
  final String driverName;
  final double driverRating;
  final String driverAvatar;
  final String cookId;
  final String cookName;
  final List<TimelineStep> timeline;

  const Order({
    required this.id,
    required this.status,
    required this.estimatedArrival,
    required this.eta,
    required this.dishes,
    required this.total,
    required this.driverId,
    required this.driverName,
    required this.driverRating,
    required this.driverAvatar,
    required this.cookId,
    required this.cookName,
    required this.timeline,
  });
}

class Review {
  final String id;
  final String authorName;
  final String authorAvatar;
  final int rating;
  final String text;
  final String timestamp;
  final String? image;

  const Review({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.text,
    required this.timestamp,
    this.image,
  });
}
