import 'dart:async';

import 'package:flutter/material.dart';

import '../data/sample_rooms.dart';
import '../l10n/app_localizations.dart';
import '../models/hotel_room.dart';
import '../services/room_service.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key, this.isReadOnlyDemo = false});

  final bool isReadOnlyDemo;

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  String _search = '';
  String _filter = 'all';
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;
    return StreamBuilder<List<HotelRoom>>(
      stream: widget.isReadOnlyDemo
          ? Stream.value(sampleRooms)
          : RoomService.instance.watchRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _RoomMessage(
            icon: Icons.cloud_off_outlined,
            text: strings.roomMessageError,
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = snapshot.data!;
        final visibleRooms = rooms.where((room) {
          final matchesSearch =
              room.roomNumber.toLowerCase().contains(_search) ||
              room.roomType.toLowerCase().contains(_search);
          final matchesStatus = _filter == 'all' || room.status.name == _filter;
          return matchesSearch && matchesStatus;
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final title = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.rooms,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.roomsDescription,
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ],
                      );
                      if (constraints.maxWidth < 560) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title,
                            if (!widget.isReadOnlyDemo) ...[
                              const SizedBox(height: 14),
                              FilledButton.icon(
                                onPressed: _saving
                                    ? null
                                    : () => _showRoomForm(rooms),
                                icon: const Icon(Icons.add),
                                label: Text(strings.addRoom),
                              ),
                            ],
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: title),
                          if (!widget.isReadOnlyDemo)
                            FilledButton.icon(
                              onPressed: _saving
                                  ? null
                                  : () => _showRoomForm(rooms),
                              icon: const Icon(Icons.add),
                              label: Text(strings.addRoom),
                            ),
                        ],
                      );
                    },
                  ),
                  if (_saving)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _RoomCount(label: strings.totalRooms(rooms.length)),
                      _RoomCount(
                        label: strings.roomsNeedCleaning(
                          rooms
                              .where(
                                (room) =>
                                    room.status == RoomStatus.needsCleaning,
                              )
                              .length,
                        ),
                      ),
                      SizedBox(
                        width: 260,
                        child: TextField(
                          onChanged: (value) => setState(
                            () => _search = value.trim().toLowerCase(),
                          ),
                          decoration: InputDecoration(
                            labelText: strings.searchRooms,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: DropdownButtonFormField<String>(
                          initialValue: _filter,
                          decoration: InputDecoration(
                            labelText: strings.roomStatus,
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(strings.allRooms),
                            ),
                            ...RoomStatus.values.map(
                              (status) => DropdownMenuItem(
                                value: status.name,
                                child: Text(_roomStatusLabel(status, strings)),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _filter = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (visibleRooms.isEmpty)
                    _RoomMessage(
                      icon: Icons.meeting_room_outlined,
                      text: rooms.isEmpty
                          ? strings.noRoomsYet
                          : strings.noRoomsMatch,
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900
                            ? 3
                            : constraints.maxWidth >= 580
                            ? 2
                            : 1;
                        final width =
                            (constraints.maxWidth - (columns - 1) * 16) /
                            columns;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: visibleRooms
                              .map(
                                (room) => SizedBox(
                                  width: width,
                                  child: _RoomCard(
                                    room: room,
                                    strings: strings,
                                    isReadOnlyDemo: widget.isReadOnlyDemo,
                                    onEdit: widget.isReadOnlyDemo
                                        ? null
                                        : () => _showRoomForm(rooms, room),
                                    onDelete: widget.isReadOnlyDemo
                                        ? null
                                        : () => _deleteRoom(room),
                                    onStatusChanged: (status) =>
                                        _setStatus(room, status),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRoomForm(
    List<HotelRoom> existing, [
    HotelRoom? room,
  ]) async {
    if (widget.isReadOnlyDemo) return;
    final strings = AppLocalizations.of(context)!;
    final result = await showDialog<HotelRoom>(
      context: context,
      builder: (context) => _RoomFormDialog(room: room),
    );
    if (result == null || !mounted) return;

    final duplicate = existing.any(
      (item) =>
          item.id != room?.id &&
          item.roomNumber.toLowerCase() == result.roomNumber.toLowerCase(),
    );
    if (duplicate) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.duplicateRoom)));
      return;
    }

    setState(() => _saving = true);
    try {
      if (room == null) {
        await RoomService.instance.addRoom(result);
      } else {
        await RoomService.instance.updateRoom(result);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(room == null ? strings.roomAdded : strings.roomUpdated),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.roomSaveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _setStatus(HotelRoom room, RoomStatus status) async {
    if (widget.isReadOnlyDemo) return;
    try {
      await RoomService.instance.updateStatus(room.id, status);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.roomStatusError)),
      );
    }
  }

  Future<void> _deleteRoom(HotelRoom room) async {
    if (widget.isReadOnlyDemo) return;
    final strings = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteRoomQuestion(room.roomNumber)),
        content: Text(strings.removeRoomConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await RoomService.instance.deleteRoom(room.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.roomDeleteError)));
    }
  }
}

class _RoomCount extends StatelessWidget {
  const _RoomCount({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.strings,
    required this.isReadOnlyDemo,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });
  final HotelRoom room;
  final AppLocalizations strings;
  final bool isReadOnlyDemo;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<RoomStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = _roomStatusColor(room.status);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.14),
                  foregroundColor: statusColor,
                  child: const Icon(Icons.meeting_room_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    strings.roomTitle(_roomNumber(room.roomNumber)),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!isReadOnlyDemo)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(strings.editRoom),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(strings.deleteRoom),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${_roomTypeLabel(room.roomType, strings)}${room.floor.isEmpty ? '' : ' • ${strings.roomFloor(room.floor)}'}',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RoomStatus>(
              initialValue: room.status,
              decoration: InputDecoration(
                labelText: strings.housekeepingStatus,
                floatingLabelStyle: TextStyle(color: statusColor),
                border: const OutlineInputBorder(),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: statusColor.withValues(alpha: 0.6),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: statusColor, width: 2),
                ),
              ),
              items: RoomStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(_roomStatusLabel(status, strings)),
                    ),
                  )
                  .toList(),
              onChanged: isReadOnlyDemo
                  ? null
                  : (status) {
                      if (status != null && status != room.status) {
                        onStatusChanged(status);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomFormDialog extends StatefulWidget {
  const _RoomFormDialog({this.room});
  final HotelRoom? room;

  @override
  State<_RoomFormDialog> createState() => _RoomFormDialogState();
}

class _RoomFormDialogState extends State<_RoomFormDialog> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _number;
  late final TextEditingController _floor;
  late String _type;
  late RoomStatus _status;

  static const _types = [
    'Standard',
    'Single',
    'Double',
    'Twin',
    'Suite',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _number = TextEditingController(text: widget.room?.roomNumber ?? '');
    _floor = TextEditingController(text: widget.room?.floor ?? '');
    _type = widget.room?.roomType ?? _types.first;
    _status = widget.room?.status ?? RoomStatus.needsCleaning;
  }

  @override
  void dispose() {
    _number.dispose();
    _floor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.room == null ? strings.addRoom : strings.editRoom),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: strings.roomNumberLabel,
                  hintText: strings.roomNumberHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? strings.roomNumberRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _floor,
                decoration: InputDecoration(labelText: strings.floorOptional),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(labelText: strings.roomType),
                items: _types
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_roomTypeLabel(type, strings)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RoomStatus>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: strings.housekeepingStatus,
                ),
                items: RoomStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(_roomStatusLabel(status, strings)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(
            widget.room == null ? strings.addRoom : strings.saveChanges,
          ),
        ),
      ],
    );
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      HotelRoom(
        id: widget.room?.id ?? '',
        roomNumber: _number.text.trim(),
        floor: _floor.text.trim(),
        roomType: _type,
        status: _status,
      ),
    );
  }
}

class _RoomMessage extends StatelessWidget {
  const _RoomMessage({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

String _roomStatusLabel(RoomStatus status, AppLocalizations strings) =>
    switch (status) {
      RoomStatus.ready => strings.ready,
      RoomStatus.needsCleaning => strings.needsCleaning,
      RoomStatus.cleaning => strings.cleaningInProgress,
      RoomStatus.maintenance => strings.maintenance,
    };

String _roomNumber(String roomNumber) => roomNumber.trim().replaceFirst(
  RegExp(r'^room\s+', caseSensitive: false),
  '',
);

String _roomTypeLabel(String type, AppLocalizations strings) =>
    switch (type.toLowerCase()) {
      'standard' => strings.standard,
      'single' => strings.single,
      'double' => strings.double,
      'twin' => strings.twin,
      'suite' => strings.suite,
      'other' => strings.other,
      _ => type,
    };

Color _roomStatusColor(RoomStatus status) => switch (status) {
  RoomStatus.ready => const Color(0xFF13A879),
  RoomStatus.needsCleaning => const Color(0xFFEF9D16),
  RoomStatus.cleaning => const Color(0xFF079EBD),
  RoomStatus.maintenance => const Color(0xFFE84D5B),
};
