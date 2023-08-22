(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\s*?EHLO\s+\d[\d\u{2e}]{500}/
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "EHLO") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") ((_ re.loop 500 500) (re.union (re.range "0" "9") (str.to_re "."))) (str.to_re "/\u{0a}"))))
; User-Agent\x3A.*community\w+\u{0d}\u{0a}subject=GhostVoice
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "community") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}"))))
; Google\s+jupitersatellites\x2Ebiz\s+Eyewww\x2Eccnnlc\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Google") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jupitersatellites.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eyewww.ccnnlc.com\u{13}\u{0a}")))))
; ^((Fred|Wilma)\s+Flintstone|(Barney|Betty)\s+Rubble)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Fred") (str.to_re "Wilma")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Flintstone")) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "RubbleB") (re.union (str.to_re "arney") (str.to_re "etty")))) (str.to_re "\u{0a}")))))
; Host\x3A\s+\x2APORT3\x2A\[DRIVEwww\.raxsearch\.comSubject\u{3a}Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*[DRIVEwww.raxsearch.comSubject:Host:\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
