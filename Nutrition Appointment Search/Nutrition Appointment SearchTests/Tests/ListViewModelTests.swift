import Combine
import XCTest
@testable import Nutrition_Appointment_Search

final class ListViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadProfessionals_Success() {
        let expectedProfessionals = [
            Professional(id: 0, name: "name 0", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 1, name: "name 1", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        ]
        
        let mockAPIService = MockAPIService()
        mockAPIService.response = ProfessionalsResponse(count: 2, offset: 0, limit: 2, professionals: expectedProfessionals)
        
        let sut = ListViewModel(apiService: mockAPIService)
        
        let expectation = self.expectation(description: "Professionals loaded")
        
        sut.$professionals
            .sink { professionals in
                if professionals.count == 2 {
                    XCTAssertEqual(professionals.count, 2)
                    XCTAssertEqual(professionals.first?.name, "name 0")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadProfessionals()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadProfessionals_Failure() {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldReturnError = true
        
        let sut = ListViewModel(apiService: mockAPIService)
        
        let expectation = self.expectation(description: "Professionals load failure")
        
        sut.$errorMessage
            .sink { errorMessage in
                if errorMessage?.contains("Failed to load professionals") == true {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadProfessionals()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPagination() {
        let initialProfessionals = [
            Professional(id: 0, name: "name 0", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 1, name: "name 1", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 2, name: "name 2", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 3, name: "name 3", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 4, name: "name 4", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 5, name: "name 5", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        ]
        
        let nextPageProfessionals = [
            Professional(id: 6, name: "name 6", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 7, name: "name 7", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        ]
        
        let mockAPIService = MockAPIService()
        mockAPIService.response = ProfessionalsResponse(count: 8, offset: 0, limit: 6, professionals: initialProfessionals)
        
        let sut = ListViewModel(apiService: mockAPIService)
        
        let expectation = self.expectation(description: "Professionals loaded")
        
        sut.$professionals
            .sink { professionals in
                if professionals.count == 6 {
                    XCTAssertEqual(professionals.count, 6)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadProfessionals()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(sut.professionals.count, 6)
        
        mockAPIService.response = ProfessionalsResponse(count: 8, offset: 6, limit: 6, professionals: nextPageProfessionals)
        
        let paginationExpectation = self.expectation(description: "Professionals paginated")
        
        sut.$professionals
            .sink { professionals in
                if professionals.count == 8 {
                    XCTAssertEqual(professionals.count, 8)
                    XCTAssertEqual(professionals[6].name, "name 6")
                    paginationExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.paginateIfNeeded(for: initialProfessionals.last!)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSortOptionChange() {
        let expectedProfessionals = [
            Professional(id: 0, name: "name 0", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil),
            Professional(id: 1, name: "name 1", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
        ]
        
        let mockAPIService = MockAPIService()
        mockAPIService.response = ProfessionalsResponse(count: 2, offset: 0, limit: 2, professionals: expectedProfessionals)
        
        let sut = ListViewModel(apiService: mockAPIService)
        
        let expectation = self.expectation(description: "Sort option changed")
        
        sut.$professionals
            .sink { professionals in
                if professionals.count == 2 {
                    XCTAssertEqual(professionals.count, 2)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.selectedSortBy = .rating
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
