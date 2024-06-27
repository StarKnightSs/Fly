//
// AppConfigManager.swift
// Created by Arpit Williams on 26/06/24.
// Copyright (c) 2024 StarKnights Technologies

import UIKit

public final class AppConfigManager: AppConfigManagerProtocol {

  public func getConfig() async throws -> AppConfig {

    // Get device unique identifier
    guard let uuid = await UIDevice.current.identifierForVendor else {
      throw ApiError.identifierNotValid
    }

    // Create request url
    guard let baseUrl = URL.baseUrl,
          let url = URL(string: "/flyServer/appConfig", relativeTo: baseUrl)
    else { throw ApiError.requestNotValid }

    // Create json payload to send using file count from user defaults
    let fileCount = UserDefaults.standard.integer(forKey: "fileCount")
    let payload = AppConfig.create(with: uuid, fileCount: fileCount)
    let jsonData = try JSONEncoder().encode(payload)

    // Create POST request
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    // Await for response
    let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)

    // Check if response is valid
    guard let response = response as? HTTPURLResponse,
          response.statusCode == 200
    else { throw ApiError.responseNotValid }

    // Create app config from response data
    let appConfig = try JSONDecoder().decode(AppConfig.self, from: data)

    return appConfig
  }
}
