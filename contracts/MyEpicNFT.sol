pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] firstWords = [
        "the",
        "be",
        "to",
        "of",
        "and",
        "a",
        "in",
        "that",
        "have",
        "I",
        "it",
        "for",
        "not",
        "on",
        "with",
        "he",
        "as",
        "you",
        "do",
        "at",
        "this",
        "but",
        "his",
        "by",
        "from",
        "they",
        "we",
        "say",
        "her",
        "she",
        "or",
        "an",
        "will",
        "my",
        "one",
        "all",
        "would",
        "there",
        "their",
        "what",
        "so",
        "up",
        "out",
        "if",
        "about",
        "who",
        "get",
        "which",
        "go",
        "me",
        "when",
        "make",
        "can",
        "like",
        "time",
        "no",
        "just",
        "him",
        "know",
        "take",
        "person",
        "into",
        "year",
        "your",
        "good",
        "some",
        "could",
        "them",
        "see",
        "other",
        "than",
        "then",
        "now",
        "look",
        "only",
        "come",
        "its",
        "over",
        "think",
        "also",
        "back",
        "after",
        "use",
        "two",
        "how",
        "our",
        "work",
        "first",
        "well",
        "way",
        "even",
        "new",
        "want",
        "because",
        "any",
        "these",
        "give",
        "day",
        "most",
        "us"
    ];
    string[] secondWords = [
        "das",
        "sein",
        "von",
        "und",
        "ein",
        "in",
        "dass",
        "habe",
        "ich",
        "es",
        "fur",
        "nicht",
        "auf",
        "mit",
        "er",
        "wie",
        "du",
        "bei",
        "diesem",
        "sondern",
        "seinem",
        "von",
        "von",
        "sie",
        "wir",
        "sagen",
        "sie",
        "sie",
        "oder",
        "eine",
        "werden",
        "meine",
        "eine",
        "alle",
        "wurden",
        "dort",
        "ihre",
        "was",
        "also",
        "oben",
        "aus",
        "wenn",
        "uber",
        "wer",
        "bekommen",
        "was",
        "gehen",
        "ich",
        "wenn",
        "machen",
        "konnen",
        "mogen",
        "Zeit",
        "nein",
        "nur",
        "ihn",
        "wissen",
        "nehmen",
        "Person",
        "in",
        "Jahr",
        "Ihre",
        "guten",
        "einige",
        "konnten",
        "sie",
        "sehen",
        "andere",
        "als",
        "dann",
        "jetzt",
        "schauen",
        "nur",
        "komm",
        "es",
        "vorbei",
        "denke",
        "auch",
        "zuruck",
        "nach",
        "gebrauch",
        "zwei",
        "wie",
        "unsere",
        "arbeit",
        "zunachst",
        "nun",
        "sogar",
        "neu",
        "wollen",
        "weil",
        "jede",
        "diese",
        "geben",
        "tag",
        "die",
        "meisten",
        "uns"
    ];
    string[] thirdWords = [
        "el",
        "ser",
        "a",
        "de",
        "y",
        "un",
        "en",
        "que",
        "tengo",
        "yo",
        "lo",
        "por",
        "no",
        "en",
        "con",
        "el",
        "como",
        "tu",
        "haces",
        "en",
        "esto",
        "sino",
        "su",
        "por",
        "de",
        "ellos",
        "nosotros",
        "decimos",
        "ella",
        "ella",
        "o",
        "un",
        "voluntad",
        "mi",
        "uno",
        "todos",
        "estarian",
        "alli",
        "sus",
        "que",
        "entonces",
        "arriba",
        "fuera",
        "si",
        "acerca de",
        "quien",
        "obtener",
        "cual",
        "ir",
        " yo",
        "cuando",
        "hacer",
        "puede",
        "como",
        "tiempo",
        "no",
        "solo",
        "el",
        "sabe",
        "llevar",
        "persona",
        "a",
        "ano",
        "su",
        "bien",
        "algunos",
        "podrian",
        "ellos",
        "ver",
        "otros",
        "que",
        "entonces",
        "ahora",
        "mirar",
        "solo",
        "venga",
        "se acabo",
        "pensar",
        "tambien",
        "atras",
        "despues",
        "usar",
        "dos",
        "como",
        "nuestro",
        "trabajo",
        "primero",
        "bueno",
        "forma",
        "incluso",
        "nuevo",
        "quiero",
        "porque",
        "cualquiera",
        "estos",
        "da",
        "dia",
        "la mayoria",
        "nosotros"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
