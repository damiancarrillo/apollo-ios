import XCTest
import Nimble
@testable import ApolloCodegenLib
import ApolloCodegenInternalTestHelpers

class SelectionSetTemplate_RenderOperation_Tests: XCTestCase {

  var schemaSDL: String!
  var document: String!
  var ir: IR!
  var operation: IR.Operation!
  var subject: SelectionSetTemplate!

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    schemaSDL = nil
    document = nil
    ir = nil
    operation = nil
    subject = nil
    super.tearDown()
  }

  // MARK: - Helpers

  func buildSubjectAndOperation(
    named operationName: String = "TestOperation",
    moduleType: ApolloCodegenConfiguration.SchemaTypesFileOutput.ModuleType = .swiftPackageManager,
    operations: ApolloCodegenConfiguration.OperationsFileOutput = .inSchemaModule
  ) throws {
    ir = try .mock(schema: schemaSDL, document: document)
    let operationDefinition = try XCTUnwrap(ir.compilationResult[operation: operationName])
    operation = ir.build(operation: operationDefinition)
    let config = ApolloCodegen.ConfigurationContext(config: .mock(
      output: .mock(moduleType: moduleType, operations: operations)
    ))
    let mockTemplateRenderer = MockTemplateRenderer(
      target: .operationFile,
      template: "",
      config: config
    )
    subject = SelectionSetTemplate(
      generateInitializers: false,
      config: config,
      accessControlRenderer: mockTemplateRenderer.embeddedAccessControlModifier(
        target: mockTemplateRenderer.target
      )
    )
  }

  func buildSchemaAndDocument() {
    schemaSDL = """
    type Query {
      allAnimals: [Animal!]
    }

    interface Animal {
      species: String!
    }
    """

    document = """
    query TestOperation {
      allAnimals {
        species
      }
    }
    """
  }

  // MARK: - Tests

  func test__render__givenOperationWithName_rendersDeclaration() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    public struct Data: TestSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation()
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
    expect(String(actual.reversed())).to(equalLineByLine("}", ignoringExtraLines: true))
  }

  // MARK: Access Level Tests

  func test__render__givenOperation_whenModuleType_swiftPackageManager_andOperations_inSchemaModule_shouldRenderWithPublicAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    public struct Data: TestSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(moduleType: .swiftPackageManager, operations: .inSchemaModule)
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_embeddedInTargetWithPublicAccessModifier_andOperations_inSchemaModule_shouldRenderWithPublicAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    public struct Data: TestSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .embeddedInTarget(name: "TestTarget", accessModifier: .public),
      operations: .inSchemaModule
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_embeddedInTargetWithInternalAccessModifier_andOperations_inSchemaModule_shouldRenderWithInternalAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    struct Data: TestSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .embeddedInTarget(name: "TestTarget", accessModifier: .internal),
      operations: .inSchemaModule
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_swiftPackageManager_andOperations_relativeWithPublicAccessModifier_shouldRenderWithPublicAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    public struct Data: TestSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .swiftPackageManager,
      operations: .relative(subpath: nil, accessModifier: .public)
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_swiftPackageManager_andOperations_relativeWithInternalAccessModifier_shouldRenderWithInternalAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    struct Data: TestSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .swiftPackageManager,
      operations: .relative(subpath: nil, accessModifier: .internal)
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_swiftPackageManager_andOperations_absoluteWithPublicAccessModifier_shouldRenderWithPublicAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    public struct Data: TestSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .swiftPackageManager,
      operations: .absolute(path: "", accessModifier: .public)
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test__render__givenOperation_whenModuleType_swiftPackageManager_andOperations_absoluteWithInternalAccessModifier_shouldRenderWithInternalAccess() throws {
    // given
    buildSchemaAndDocument()

    let expected = """
    struct Data: TestSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { TestSchema.Objects.Query }
    """

    // when
    try buildSubjectAndOperation(
      moduleType: .swiftPackageManager,
      operations: .absolute(path: "", accessModifier: .internal)
    )
    let actual = subject.render(for: operation)

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

}
