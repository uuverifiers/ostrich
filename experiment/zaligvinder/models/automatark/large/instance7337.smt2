(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BTrojan\x3Abacktrust\x2EcomHost\x3Apjpoptwql\u{2f}rlnj
(assert (str.in_re X (str.to_re "}{Trojan:backtrust.comHost:pjpoptwql/rlnj\u{0a}")))
; /filename=[^\n]*\u{2e}qt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qt/i\u{0a}")))))
; /\x2Fevil\x2Fservices\x2Fbid_register\x2Ephp\x3FBID\x3D[A-Za-z]{6}\u{26}IP\x3D\d{1,3}\x2E\d{1,3}\x2E\d{1,3}\x2E\d{1,3}\u{26}cipher\x3D[A-Za-z]{9}/smiU
(assert (str.in_re X (re.++ (str.to_re "//evil/services/bid_register.php?BID=") ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "&IP=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&cipher=") ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "/smiU\u{0a}"))))
; ^([2][0]\d{2}\/([0]\d|[1][0-2])\/([0-2]\d|[3][0-1]))$|^([2][0]\d{2}\/([0]\d|[1][0-2])\/([0-2]\d|[3][0-1])\s([0-1]\d|[2][0-3])\:[0-5]\d\:[0-5]\d)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")))) (re.++ (str.to_re "\u{0a}20") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))))
; /\/se\/[a-f0-9]{100,200}\/[a-f0-9]{6,9}\/[A-Z0-9_]{4,200}\.com/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//se/") ((_ re.loop 100 200) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 6 9) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 4 200) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re ".com/Ui\u{0a}")))))
(check-sat)
