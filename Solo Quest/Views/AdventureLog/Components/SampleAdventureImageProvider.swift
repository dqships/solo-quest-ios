//
//  SampleAdventureImageProvider.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

enum SampleAdventureImageProvider {
    private static let allImages = [
        "SampleAdventure1", "SampleAdventure2", "SampleAdventure3", "SampleAdventure4",
        "SampleAdventure5", "SampleAdventure6", "SampleAdventure7", "SampleAdventure8",
        "SampleAdventure9", "SampleAdventure10", "SampleAdventure11", "SampleAdventure12",
        "SampleAdventure13", "SampleAdventure14", "SampleAdventure15", "SampleAdventure16",
        "SampleAdventure17", "SampleAdventure18", "SampleAdventure19", "SampleAdventure20",
        "SampleAdventure21", "SampleAdventure22", "SampleAdventure23", "SampleAdventure25",
        "SampleAdventure26", "SampleAdventure27"
    ]
    
    static let displayImages: [String] = Array(allImages.shuffled().prefix(12))
}
