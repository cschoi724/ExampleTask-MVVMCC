//
//  UserDTO.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import Foundation

// MARK: - User
struct UserDTO: Codable {
    let gender: String
    let name: NameDTO!
    let location: LocationDTO!
    let email: String
    let login: LoginDTO!
    let dob: DayOfBirthDTO!
    let registered: DayOfBirthDTO!
    let phone: String
    let cell: String
    let id: IdentifyDTO!
    let picture: PictureDTO!
    let nat: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = (try? container.decode(String.self, forKey: .gender)) ?? ""
        self.name = (try? container.decodeIfPresent(NameDTO.self, forKey: .name))
        self.location = (try? container.decodeIfPresent(LocationDTO.self, forKey: .location))
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.login = (try? container.decodeIfPresent(LoginDTO.self, forKey: .login))
        self.dob = (try? container.decodeIfPresent(DayOfBirthDTO.self, forKey: .dob))
        self.registered = (try? container.decodeIfPresent(DayOfBirthDTO.self, forKey: .registered))
        self.phone = (try? container.decode(String.self, forKey: .phone)) ?? ""
        self.cell = (try? container.decode(String.self, forKey: .cell)) ?? ""
        self.id = (try? container.decodeIfPresent(IdentifyDTO.self, forKey: .id))
        self.picture = (try? container.decodeIfPresent(PictureDTO.self, forKey: .picture))
        self.nat = (try? container.decode(String.self, forKey: .nat)) ?? ""
    }
}

// MARK: - Login
struct LoginDTO: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = (try? container.decode(String.self, forKey: .uuid)) ?? ""
        self.username = (try? container.decode(String.self, forKey: .username)) ?? ""
        self.password = (try? container.decode(String.self, forKey: .password)) ?? ""
        self.salt = (try? container.decode(String.self, forKey: .salt)) ?? ""
        self.md5 = (try? container.decode(String.self, forKey: .md5)) ?? ""
        self.sha1 = (try? container.decode(String.self, forKey: .sha1)) ?? ""
        self.sha256 = (try? container.decode(String.self, forKey: .sha256)) ?? ""
    }
}

// MARK: - Name
struct NameDTO: Codable {
    let title, first, last: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.first = (try? container.decode(String.self, forKey: .first)) ?? ""
        self.last = (try? container.decode(String.self, forKey: .last)) ?? ""
    }
}

// MARK: - Dob
struct DayOfBirthDTO: Codable {
    let date: String
    let age: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = (try? container.decode(String.self, forKey: .date)) ?? ""
        self.age = (try? container.decode(Int.self, forKey: .age)) ?? 0
    }
}

// MARK: - ID
struct IdentifyDTO: Codable {
    let name, value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.value = (try? container.decode(String.self, forKey: .value)) ?? ""
    }
}

// MARK: - Picture
struct PictureDTO: Codable {
    let large, medium, thumbnail: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.large = (try? container.decode(String.self, forKey: .large)) ?? ""
        self.medium = (try? container.decode(String.self, forKey: .medium)) ?? ""
        self.thumbnail = (try? container.decode(String.self, forKey: .thumbnail)) ?? ""
    }
}

// MARK: - Location
struct LocationDTO: Codable {
    let street: StreetDTO!
    let city: String
    let state: String
    let country: String
    let postcode: Int
    let coordinates: CoordinateDTO!
    let timezone: TimezoneDTO!
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.street = (try? container.decode(StreetDTO.self, forKey: .street))
        self.city = (try? container.decode(String.self, forKey: .city)) ?? ""
        self.state = (try? container.decode(String.self, forKey: .state)) ?? ""
        self.country = (try? container.decode(String.self, forKey: .country)) ?? ""
        self.postcode = (try? container.decode(Int.self, forKey: .postcode)) ?? 0
        self.coordinates = (try? container.decode(CoordinateDTO.self, forKey: .coordinates))
        self.timezone = (try? container.decode(TimezoneDTO.self, forKey: .timezone))
    }
}

// MARK: - Street
struct StreetDTO: Codable {
    let number: Int
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = (try? container.decode(Int.self, forKey: .number)) ?? 0
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
    }
}

// MARK: - Coordinate
struct CoordinateDTO: Codable {
    let latitude: String
    let longitude: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = (try? container.decode(String.self, forKey: .latitude)) ?? ""
        self.longitude = (try? container.decode(String.self, forKey: .longitude)) ?? ""
    }
}

// MARK: - Timezone
struct TimezoneDTO: Codable {
    let offset: String
    let description: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = (try? container.decode(String.self, forKey: .offset)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}
