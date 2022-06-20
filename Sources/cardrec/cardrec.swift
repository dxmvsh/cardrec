import Vision

public protocol CardRecProtocol {
    func recognizeText(from image: CGImage)
}

public protocol CardRecDelegate: AnyObject {
    func didFinishRecognition(of image: CGImage, _ result: Result<[String], Error>)
}

public enum CardRecError: Error {
    case detectionError
    case noTextObserved
}

class CardRec: NSObject, CardRecProtocol {
    
    weak var delegate: CardRecDelegate?
    
    lazy var textDetectionRequest: VNRecognizeTextRequest = {
        return VNRecognizeTextRequest(completionHandler: handleTextDetection)
    }()
    
    private var currentImage: CGImage?
    
    func recognizeText(from image: CGImage, completion: ((Result<[String], Error>) -> Void)) {
        currentImage = image
        let imageRequestHandler = VNImageRequestHandler(
            cgImage: image,
            options: [:]
        )
        do {
            try imageRequestHandler.perform([textDetectionRequest])
        } catch {
            delegate?.didFinishRecognition(of: image, .failure(error))
        }
    }
    
    private func handleTextDetection(_ request: VNRequest, _ error: Error?) {
        guard let currentImage = currentImage else {
            return
        }
        guard error == nil else {
            delegate?.didFinishRecognition(of: currentImage, .failure(CardRecError.detectionError))
            return
        }
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            delegate?.didFinishRecognition(of: currentImage, .failure(CardRecError.noTextObserved))
            return
        }
        let texts = observations.compactMap { $0.topCandidates(1).first?.string }
        delegate?.didFinishRecognition(of: currentImage, .success(texts))
    }
    
}
