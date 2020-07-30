module Types::Interface::Media
  include Types::Interface::Base
  include HasLocalizedField

  orphan_types Types::Manga, Types::Anime
  description 'A media in the Kitsu database'

  # Identifiers
  field :id, ID, null: false

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this media'

  field :type, String,
    null: false,
    description: 'Anime or Manga.'

  # Types::Anime -> Anime
  def type
    self.class.name.split('::').last
  end

  # Localized Titles
  field :titles, Types::TitlesList,
    null: false,
    description: 'The titles for this media in various locales'

  def titles
    {
      localized: object.titles,
      alternatives: object.abbreviated_titles.presence || [],
      canonical: object.canonical_title,
      canonical_locale: object.canonical_title_key
    }
  end

  # Localized Synopsis
  localized_field :synopsis,
    null: false,
    description: 'A brief (mostly spoiler-free) summary/description of the media'

  def synopsis
    # TODO: actually store localized synopsis data
    { en: object.synopsis } if object.synopsis
  end

  # Age Rating
  field :age_rating, Types::Enum::AgeRating,
    null: true,
    description: 'The recommended minimum age group for this media'

  field :age_rating_guide, String,
    null: true,
    description: 'An explanation of why this received the age rating it did'

  field :sfw, Boolean,
    null: false,
    description: 'Whether the media is Safe-for-Work',
    method: :sfw?

  # Release Information
  field :start_date, Types::Date,
    null: true,
    description: 'The day that this media first released'

  field :end_date, Types::Date,
    null: true,
    description: 'the day that this media made its final release'

  field :next_release, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time of the next release of this media'

  field :status, Types::Enum::ReleaseStatus,
    null: false,
    description: 'The current releasing status of this media'

  field :season, Types::Enum::ReleaseSeason,
    null: true,
    description: 'The season this was released in'

  field :tba,
    String,
    null: true,
    description: 'Description of when this media is expected to release'

  # User Ratings
  field :average_rating, Float,
    null: true,
    description: 'The average rating of this media amongst all Kitsu users'

  field :user_count, Integer,
    null: true,
    description: 'The number of users with this in their library'

  field :favorites_count, Integer,
    null: true,
    description: 'The number of users with this in their favorites'

  # Images
  field :poster_image, Types::Image,
    null: false,
    description: 'The poster image of this media'

  field :banner_image, Types::Image,
    method: :cover_image,
    null: false,
    description: 'A large banner image for this media'

  # Cast
  field :characters, Types::MediaCharacter.connection_type,
    null: false,
    description: 'The characters who starred in this media'

  def characters
    AssociationLoader.for(object.class, :characters).scope(object)
  end

  field :staff, Types::MediaStaff.connection_type,
    null: false,
    description: 'The staff members who worked on this media'

  def staff
    AssociationLoader.for(object.class, :staff, policy: :media_staff).scope(object)
  end

  field :productions, Types::MediaProduction.connection_type,
    null: false,
    description: 'The companies which helped to produce this media'

  def productions
    AssociationLoader.for(object.class, :productions, policy: :media_production).scope(object)
  end

  field :quotes, Types::Quote.connection_type,
    null: false,
    description: 'A list of quotes from this media'

  def quotes
    AssociationLoader.for(object.class, :quotes).scope(object).then(&:to_a)
  end

  field :categories, Types::Category.connection_type,
    null: false,
    description: 'A list of categories for this media'

  def categories
    AssociationLoader.for(object.class, :categories).scope(object)
  end

  field :mappings, Types::Mapping.connection_type,
    null: false,
    description: 'A list of mappings for this media'

  def mappings
    AssociationLoader.for(object.class, :mappings).scope(object)
  end

  field :reactions, Types::MediaReaction.connection_type,
    null: false,
    description: 'A list of reactions for this media'

  def reactions
    AssociationLoader.for(object.class, :media_reactions).scope(object)
  end
end
