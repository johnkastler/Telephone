//
//  UserAgentSoundIOSelectionUseCaseTests.swift
//  Telephone
//
//  Copyright © 2008-2016 Alexey Kuznetsov
//  Copyright © 2016-2018 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import Domain
import DomainTestDoubles
@testable import UseCases
import UseCasesTestDoubles
import XCTest

final class UserAgentSoundIOSelectionUseCaseTests: XCTestCase {
    func testSelectsPreferredMappedAudioDevices() throws {
        let factory = SystemAudioDevicesTestFactory(factory: SystemAudioDeviceTestFactory())
        let agent = UserAgentSpy()
        agent.audioDevicesResult = [
            UserAgentAudioDevice(device: SystemAudioDeviceTestFactory().firstBuiltInOutput),
            UserAgentAudioDevice(device: SystemAudioDeviceTestFactory().firstBuiltInInput)
        ]
        let settings = SettingsFake()
        let sut = UserAgentSoundIOSelectionUseCase(factory: factory, userAgent: agent, settings: settings)

        try sut.execute()

        XCTAssertEqual(
            agent.invokedInputDeviceID,
            PreferredSoundIO(devices: try factory.make(), settings: settings).input.identifier
        )
        XCTAssertEqual(
            agent.invokedOutputDeviceID,
            PreferredSoundIO(devices: try factory.make(), settings: settings).output.identifier
        )
    }
}
