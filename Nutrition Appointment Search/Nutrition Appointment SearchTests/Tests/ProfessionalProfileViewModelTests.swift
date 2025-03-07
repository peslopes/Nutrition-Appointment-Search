import XCTest
import Combine
@testable import Nutrition_Appointment_Search

class ProfessionalProfileViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchProfessional_Success() {
        let expectedProfessional = Professional(id: 0, name: "name 0", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        let mockAPIService = MockAPIService()
        mockAPIService.getProfessionalProfileResponse = expectedProfessional
        let sut = ProfessionalProfileViewModel(apiService: mockAPIService, professionalId: 1)
        
        let expectation = XCTestExpectation(description: "Fetch professional success")
        
        sut.fetchProfessional()
        
        sut.$professional
            .dropFirst()
            .sink { professional in
                XCTAssertEqual(professional, expectedProfessional)
                XCTAssertFalse(sut.isLoading)
                XCTAssertNil(sut.errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchProfessional_Failure() {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldReturnError = true
        
        let sut = ProfessionalProfileViewModel(apiService: mockAPIService, professionalId: 1)
        
        let expectation = self.expectation(description: "Professional profile load failure")
        
        sut.$errorMessage
            .sink { errorMessage in
                if errorMessage?.contains("Failed to load professional profile") == true {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.fetchProfessional()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchProfessionalLoadingState() {
        let expectedProfessional = Professional(id: 0, name: "name 0", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        let mockAPIService = MockAPIService()
        mockAPIService.getProfessionalProfileResponse = expectedProfessional
        let sut = ProfessionalProfileViewModel(apiService: mockAPIService, professionalId: 1)
        
        let expectation = XCTestExpectation(description: "Fetch professional loading state")

        sut.fetchProfessional()
        
        sut.$isLoading
            .sink { isLoading in
                if isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
