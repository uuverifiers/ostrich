(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Supreme\d+Host\x3A\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}"))))
; ChildWebGuardian\d+Subject\x3A
(assert (str.in_re X (re.++ (str.to_re "ChildWebGuardian") (re.+ (re.range "0" "9")) (str.to_re "Subject:\u{0a}"))))
; /setAttributeNS\s*\u{28}[^,]*,[^,]*requiredFeatures[^,]*,\s*[\u{22}\u{27}][\s\r\n]+[\u{22}\u{27}]/i
(assert (str.in_re X (re.++ (str.to_re "/setAttributeNS") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ","))) (str.to_re ",") (re.* (re.comp (str.to_re ","))) (str.to_re "requiredFeatures") (re.* (re.comp (str.to_re ","))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/i\u{0a}"))))
; ^([1-zA-Z0-1@.\s]{1,255})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "1" "z") (re.range "A" "Z") (re.range "0" "1") (str.to_re "@") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
