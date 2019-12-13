precision highp float;

uniform vec3 cameraPosition;
uniform vec3 sphereColor;

varying vec3 vPos;
varying vec3 vNormal;
varying float vDiscard;

const vec3 LIGHT_DIR = normalize(vec3(1.0, 1.0, 1.0));

void main(void) {
  if (vDiscard == 1.0) {
    discard;
  } else {
    vec3 n = normalize(vNormal);

    vec3 light = normalize(LIGHT_DIR);
    vec3 eye = normalize(cameraPosition - vPos);
    vec3 halfLE = normalize(light + eye);
    float diffuse = clamp(dot(n, light), 0.3, 1.0);
    float specular = pow(clamp(dot(n, halfLE), 0.0, 1.0), 50.0);
    vec3 color = sphereColor * vec3(diffuse) + vec3(specular);
    gl_FragColor = vec4(color, 1.0);
  }
}