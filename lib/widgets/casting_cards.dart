import 'package:flutter/material.dart';
import 'package:peliculas_app/models/cast.dart';

class CastingCards extends StatelessWidget {
  final List<Cast> cast;
  const CastingCards({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: 200, // FIX: era 19
      child: ListView.builder(
        itemCount: cast.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) => _CastCard(actor: cast[index]),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;
  const _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: actor.profilePath != null
                ? FadeInImage(
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w200${actor.profilePath}'),
                    height: 140,
                    width: 110,
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/no-image.jpg',
                    height: 140, width: 110, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(actor.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
          Text(actor.character ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}