import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ReservationScreen extends StatefulWidget {
  final AppState appState;

  const ReservationScreen({super.key, required this.appState});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _partySize = 2;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '7:00 PM';
  String _seatingPreference = 'Window Booth';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _timeSlots = [
    '5:30 PM',
    '6:15 PM',
    '7:00 PM',
    '7:45 PM',
    '8:30 PM',
    '9:15 PM'
  ];

  final List<String> _seatingAreas = [
    'Main Dining Room',
    'Window Booth',
    'Patio Terrace',
    'Chef\'s Counter'
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reservations = widget.appState.reservations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Table'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Reservations Summary
            if (reservations.isNotEmpty) ...[
              const Text(
                'Your Active Reservations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reservations.length,
                itemBuilder: (ctx, i) {
                  final res = reservations[i];
                  return Card(
                    color: theme.primaryColor.withValues(alpha: 0.08),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.table_restaurant, color: Colors.white),
                      ),
                      title: Text(
                        '${res.partySize} Guests • ${res.timeSlot}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${res.date.day}/${res.date.month}/${res.date.year} • ${res.seatingPreference}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                        onPressed: () {
                          widget.appState.cancelReservation(res.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reservation cancelled.')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 30),
            ],

            const Text(
              'Reserve a Table at Savoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Party Size Selector
            const Text(
              'Party Size (Guests)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (ctx, i) {
                  final count = i + 1;
                  final isSelected = _partySize == count;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$count ${count == 1 ? 'Guest' : 'Guests'}'),
                      selected: isSelected,
                      selectedColor: theme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _partySize = count);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker Card
            const Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: theme.primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text('Change', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slots
            const Text(
              'Select Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: theme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedTimeSlot = slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Seating Area
            const Text(
              'Seating Preference',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _seatingPreference,
              items: _seatingAreas.map((area) {
                return DropdownMenuItem(value: area, child: Text(area));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _seatingPreference = val);
              },
            ),
            const SizedBox(height: 20),

            // Special Notes
            const Text(
              'Special Request (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Birthday, anniversary, high chair needed...',
              ),
            ),
            const SizedBox(height: 30),

            // Confirm Reservation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final res = widget.appState.bookTable(
                    date: _selectedDate,
                    timeSlot: _selectedTimeSlot,
                    partySize: _partySize,
                    seatingPreference: _seatingPreference,
                    specialRequest: _notesController.text,
                  );

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Table Reserved!'),
                        ],
                      ),
                      content: Text(
                        'Your table for $_partySize guests on ${_selectedDate.day}/${_selectedDate.month} at $_selectedTimeSlot ($_seatingPreference) has been confirmed. Ref: ${res.id}',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Great!'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Confirm Table Reservation'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
