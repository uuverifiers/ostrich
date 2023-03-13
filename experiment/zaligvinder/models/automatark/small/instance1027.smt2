(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SI\|Server\|\d+informationWinInetEvilFTPOSSProxy\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.range "0" "9")) (str.to_re "informationWinInetEvilFTPOSSProxy\u{5c}home/lordofsearch\u{0a}")))))
; /\u{2f}\?ts\u{3d}[a-f0-9]{40}\u{26}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?ts=") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&/Ui\u{0a}")))))
; /^ver\u{3a}Ghost\s+version\s+\d+\x2E\d+\s+server/smi
(assert (str.in_re X (re.++ (str.to_re "/ver:Ghost") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "server/smi\u{0a}"))))
(check-sat)
