(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}k3g/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".k3g/i\u{0a}")))))
; /\.getElements?By(Id|TagName)\u{28}\s*[\u{22}\u{27}]caption[\u{22}\u{27}]\s*\u{29}.*?innerHTML\s*\u{3d}\s*[\u{22}\u{27}]\u{3c}thead/sm
(assert (not (str.in_re X (re.++ (str.to_re "/.getElement") (re.opt (str.to_re "s")) (str.to_re "By") (re.union (str.to_re "Id") (str.to_re "TagName")) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "caption") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") (re.* re.allchar) (str.to_re "innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "<thead/sm\u{0a}")))))
; (\'([^\'\\]*\\.)*[^\'\\]*\')+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (str.to_re "'") (re.* (re.++ (re.* (re.union (str.to_re "'") (str.to_re "\u{5c}"))) (str.to_re "\u{5c}") re.allchar)) (re.* (re.union (str.to_re "'") (str.to_re "\u{5c}"))) (str.to_re "'"))) (str.to_re "\u{0a}")))))
; ((^[0-9]*).?((BIS)|(TER)|(QUATER))?)?((\W+)|(^))(([a-z]+.)*)([0-9]{5})?.(([a-z\'']+.)*)$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.* (re.range "0" "9")) (re.opt re.allchar) (re.opt (re.union (str.to_re "BIS") (str.to_re "TER") (str.to_re "QUATER"))))) (re.+ (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.* (re.++ (re.+ (re.range "a" "z")) re.allchar)) (re.opt ((_ re.loop 5 5) (re.range "0" "9"))) re.allchar (re.* (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "'"))) re.allchar)) (str.to_re "\u{0a}"))))
; www\u{2e}proventactics\u{2e}com\s+
(assert (str.in_re X (re.++ (str.to_re "www.proventactics.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(check-sat)
