(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wps/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wps/i\u{0a}")))))
; url\(['"]?([\w\d_\-\. ]+)['"]?\)
(assert (not (str.in_re X (re.++ (str.to_re "url(") (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (re.+ (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ".") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ")\u{0a}")))))
; ^([+]39)?\s?((313)|(32[03789])|(33[013456789])|(34[0256789])|(36[0368])|(37[037])|(38[0389])|(39[0123]))[\s-]?([\d]{7})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+39")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "313") (re.++ (str.to_re "32") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "33") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "34") (re.union (str.to_re "0") (str.to_re "2") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "36") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "6") (str.to_re "8"))) (re.++ (str.to_re "37") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "7"))) (re.++ (str.to_re "38") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "39") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}www\x2Eadoptim\x2Ecom
(assert (not (str.in_re X (str.to_re "User-Agent:www.adoptim.com\u{0a}"))))
; ^\d*((\.\d+)?)*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
