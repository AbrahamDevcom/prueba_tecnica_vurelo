import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String selectedLanguage;
  final int selectedYear;
  final List<String> availableLanguages;
  final List<int> availableYears;
  final Function(String) onLanguageChanged;
  final Function(int) onYearChanged;
  final VoidCallback onClearFilters;

  const FilterChips({
    super.key,
    required this.selectedLanguage,
    required this.selectedYear,
    required this.availableLanguages,
    required this.availableYears,
    required this.onLanguageChanged,
    required this.onYearChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = selectedLanguage != 'all' || selectedYear != 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Filtros',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (hasActiveFilters)
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  'Limpiar',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Language Filter
        Text(
          'Idioma',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableLanguages.length,
            itemBuilder: (context, index) {
              final language = availableLanguages[index];
              final isSelected = language == selectedLanguage;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    language == 'all' ? 'Todos' : language.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onLanguageChanged(language);
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Year Filter
        Text(
          'Año',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableYears.take(10).length, // Limit to 10 years
            itemBuilder: (context, index) {
              final year = availableYears[index];
              final isSelected = year == selectedYear;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    year == 0 ? 'Todos' : year.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onYearChanged(year);
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}