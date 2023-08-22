(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\[assembly: AssemblyVersion\(\"([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)
(assert (str.in_re X (re.++ (str.to_re "[assembly: AssemblyVersion(\u{22}") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}rp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /filename=[^\n]*\u{2e}dxf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dxf/i\u{0a}")))))
; ^[\(]? ([^0-1]){1}([0-9]){2}([-,\),/,\.])*([ ])?([^0-1]){1}([0-9]){2}[ ]?[-]?[/]?[\.]? ([0-9]){4}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re " ") ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re ",") (str.to_re ")") (str.to_re "/") (str.to_re "."))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.opt (str.to_re "-")) (re.opt (str.to_re "/")) (re.opt (str.to_re ".")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
