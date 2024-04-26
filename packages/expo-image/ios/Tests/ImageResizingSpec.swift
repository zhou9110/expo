import ExpoModulesTestCore

@testable import ExpoModulesCore
@testable import ExpoImage

class ImageResizingSpec: ExpoSpec {
  override class func spec() {
    describe("ideal size") {
      // For simplicity use the same container size for all tests
      let containerSize = CGSize(width: 150, height: 100)

      context("content size is 300x200") {
        let contentSize = CGSize(width: 300, height: 200)
        let aspectRatio = contentSize.width / contentSize.height

        it("contains") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .contain)
          expect(size.width) == containerSize.width
          expect(size.height) == containerSize.height
          expect(size.width / size.height) == aspectRatio
        }

        it("covers") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .cover)
          expect(size.width) == containerSize.width
          expect(size.height) == containerSize.height
          expect(size.width / size.height) == aspectRatio
        }

        it("fills") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .fill)
          expect(size.width) == containerSize.width
          expect(size.height) == containerSize.height
        }

        it("scales down") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .scaleDown)
          expect(size.width) == containerSize.width
          expect(size.height) == containerSize.height
        }
      }

      context("content size is 412x168") {
        let contentSize = CGSize(width: 412, height: 168)
        let aspectRatio = contentSize.width / contentSize.height

        it("contains") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .contain)
          expect(size.width) == containerSize.width
          expect(size.height) == (expected: containerSize.width / aspectRatio, delta: 0.0001)
          expect(size.width / size.height) == (expected: aspectRatio, delta: 0.0001)
        }

        it("covers") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .cover)
          expect(size.width) == (expected: containerSize.height * aspectRatio, delta: 0.0001)
          expect(size.height) == containerSize.height
          expect(size.width / size.height) == aspectRatio
        }

        it("fills") {
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .fill)
          expect(size.width) == containerSize.width
          expect(size.height) == containerSize.height
        }

        it("scales down") {
          // Behaves like 'contain'
          let size = idealSize(contentPixelSize: contentSize, containerSize: containerSize, scale: 1, contentFit: .scaleDown)
          expect(size.width) == containerSize.width
          expect(size.height) == (expected: containerSize.width / aspectRatio, delta: 0.0001)
          expect(size.width / size.height) == (expected: aspectRatio, delta: 0.0001)
        }
      }
    }

    describe("upsizing") {

    }
  }
}
