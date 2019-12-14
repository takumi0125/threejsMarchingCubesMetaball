const ENV = require('../_env');
const g = window[ENV.projectName] = window[ENV.projectName] || {};

import MarchingCubes from './MarchingCubes';

export default class Main {
  constructor() {
    this.init();
  }

  async init() {
    await this.initWebGL();
  }

  async initWebGL() {
    return new Promise(async (resolve, reject)=> {
      if(!THREE.WEBGL.isWebGLAvailable()) {
        this.isNoWebGL = true;
        reject('WebGL is not supported');
        return;
      }

      window.addEventListener('resize', this.onResize.bind(this));

      this.container = document.body.querySelector('.js-mainVisual');
      this.canvas = this.container.querySelector('canvas');

      this.width = window.innerWidth;
      this.height = window.innerHeight;

      // renderer
      this.devicePixelRatio = window.devicePixelRatio;
      this.renderer = new THREE.WebGLRenderer({
        canvas: this.canvas,
        devicePixelRatio: this.devicePixelRatio
      });
      this.renderer.setPixelRatio(this.devicePixelRatio);

      // scene
      this.scene = new THREE.Scene();

      // camera
      this.camera = new THREE.PerspectiveCamera(45, 1, 1, 1000);
      this.camera.position.z = 100;
      this.camera.lookAt(0, 0, 0);

      // controls
      this.controls = new THREE.TrackballControls(this.camera, this.canvas);
      this.controls.rotateSpeed = 4;

      // marchingCubes
      this.marchingCubes = new MarchingCubes();
      this.scene.add(this.marchingCubes.mesh);

      this.onResize();

      console.log('webgl inited');
      this.isNoWebGL = false;
      this.start();
      resolve();
    })
    .catch((error)=> {
      this.isNoWebGL = true;
      console.error(error);
    });
  }

  start() {
    if(this.isNoWebGL) return;
    this.update = this.update.bind(this);
    this.startTime = new Date().getTime() + Math.random() * 40000;
    this.update();
  }

  update() {
    this.animationId = window.requestAnimationFrame(this.update);
    this.render();
  }

  render() {
    const time = new Date().getTime() - this.startTime;
    this.controls.update();
    this.renderer.render(this.scene, this.camera);

    this.marchingCubes.update(time);
  }

  async onResize() {
    if(this.isNoWebGL) return;

    this.width = window.innerWidth;
    this.height = window.innerHeight;
    const aspectRatio =  this.width / this.height;

    this.renderer.setSize(this.width, this.height);

    this.camera.aspect   = aspectRatio;
    this.camera.updateProjectionMatrix();

    this.controls.handleResize();

    this.render();
  }
}
