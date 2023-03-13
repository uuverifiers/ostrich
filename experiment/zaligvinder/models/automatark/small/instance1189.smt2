(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /http:\\/\/\.?video.google.\w{2,3}\/videoplay\?docid=([a-z0-9-_]+)/i
(assert (str.in_re X (re.++ (str.to_re "/http:\u{5c}//") (re.opt (str.to_re ".")) (str.to_re "video") re.allchar (str.to_re "google") re.allchar ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/videoplay?docid=") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (str.to_re "/i\u{0a}"))))
; /filename=[^\n]*\u{2e}flv/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flv/i\u{0a}")))))
(check-sat)
